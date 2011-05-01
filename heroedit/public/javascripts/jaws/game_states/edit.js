var jaws = (function(jaws) {

if(!jaws.game_states) jaws.game_states = {}

jaws.game_states.Edit = function(options) {
  if(! options ) options = {};
  var game_objects = options.game_objects || []
  var grid_size = options.grid_size
  var snap_to_grid = options.snap_to_grid
  var click_at
  var edit_tag
  
  function mousedown(e) {
    var x = (e.pageX || e.clientX) - jaws.canvas.offsetLeft
    var y = (e.pageY || e.clientX) - jaws.canvas.offsetTop
    jaws.log("click @ " + x + "/" + y)
    
    if(!jaws.pressed("ctrl")) { deselect(game_objects); }
    select( gameObjectsAt(x, y) )
    click_at = [x,y]

    edit_tag.innerHTML = "Selected game objects:<br/>"
    game_objects.filter(isSelected).forEach( function(element, index) {
      edit_tag.innerHTML += element.toString() + "<br />"
    });
  }
  function mouseup(e) {
    click_at = undefined
  }
  function mousemove(e) {
    if(click_at) {
      var x = (e.pageX || e.clientX) - jaws.canvas.offsetLeft
      var y = (e.pageY || e.clientX) - jaws.canvas.offsetTop
      var snap_object = true
    
      dx = x - click_at[0]
      dy = y - click_at[1]
      click_at = [x, y]

      game_objects.filter(isSelected).forEach( function(element, index) {
        element.move(dx, dy)
        if(grid_size && snap_object) {
          x -= x % grid_size[0]
          y -= y % grid_size[1]
          element.moveTo(x,y)
          snap_object = false
        }
      });
    }
  }
  function mousewheel(e) {
    var delta
    if(e.wheelDelta ) delta = e.wheelDelta/120;
    if(e.detail     ) delta = -e.detail/3;

    game_objects.filter(isSelected).forEach( function(element, index) { element.z += delta*4 })
    //jaws.log("scroll by: " + delta)
  }

  function forceArray(obj)                { return obj.forEach ? obj : [obj] }
  function isSelected(element, index)     { return element.selected == true }
  function isNotSelected(element, index)  { return !isSelected(element) }
  function drawRect(element, index)       { element.rect().draw() }
  function select(obj) {
    forceArray(obj).forEach( function(element, index) { element.selected = true } )
  }
  function deselect(obj) {
    forceArray(obj).forEach( function(element, index) { element.selected = false; } )
  }

  function gameObjectsAt(x, y) {
    return game_objects.filter( function(obj) { return obj.rect().collidePoint(x, y) } )
  }
  function removeSelected() {
    game_objects = []
    //game_objects = game_objects.filter(isNotSelected)
  }

  /* Remove all event-listeners, hide edit_tag and switch back to previous game state */
  function exit() {
    edit_tag.style.display = "none"
    jaws.canvas.removeEventListener("mousedown", mousedown, false);
    jaws.canvas.removeEventListener("mouseup", mouseup, false);
    jaws.canvas.removeEventListener("mousemove", mousemove, false);
    jaws.canvas.removeEventListener("mousewheel", mousewheel, false);
    jaws.canvas.removeEventListener("DOMMouseSCroll", mousewheel, false);
    jaws.switchGameState(jaws.previous_game_state)
  }

  this.setup = function() {
    edit_tag = document.getElementById("jaws-edit")
    edit_tag.style.display = "block"

    jaws.log("Editor activated!")
    jaws.preventDefaultKeys(["left", "right", "up", "down", "ctrl", "f1", "f2"])
    jaws.on_keydown(["f2","esc"], exit )
    jaws.on_keydown("delete",     removeSelected )
    jaws.canvas.addEventListener("mousedown", mousedown, false);
    jaws.canvas.addEventListener("mouseup", mouseup, false);
    jaws.canvas.addEventListener("mousemove", mousemove, false);
    jaws.canvas.addEventListener("mousewheel", mousewheel, false);
    jaws.canvas.addEventListener("DOMMouseSCroll", mousewheel, false);
  }

  this.update = function() {
    
  }
  
  this.draw = function() {
    jaws.clear()
    jaws.previous_game_state.draw()
    game_objects.filter(isSelected).forEach(drawRect)

    if(grid_size) {
      jaws.context.strokeStyle = "rgba(0,0,255,0.3)";
      jaws.context.beginPath()

      for(var x=-0.5; x < jaws.width; x+=grid_size[0]) {
        jaws.context.moveTo(x, 0)
        jaws.context.lineTo(x, jaws.height)
      }
      for(var y=-0.5; y < jaws.height; y+=grid_size[1]) {
        jaws.context.moveTo(0, y)
        jaws.context.lineTo(jaws.width, y)
      }
      jaws.context.closePath()
      jaws.context.stroke()
    }
  }
}

return jaws;
})(jaws || {});
