var fps = null
var sprite
function PlayState() {
  var player
  var bullets = new jaws.SpriteList()
  var view = $('#view');
  var tilemap;
  var tiles;
  var tileset;
  var mouse = {lastPressed: false};
  var viewport;
  
  this.setup = function() {
	player = new jaws.Sprite({image: "plane.png", x: 10, y:100})
	player.can_fire = true
	jaws.on_keydown("esc",  function() { jaws.switchGameState(MenuState) })
	jaws.preventDefaultKeys(["up", "down", "left", "right", "space"])
	view.mousemove(function(event) {
		os = view.offset();
		mouse.x = event.pageX - os.left + viewport.x;
		mouse.y = event.pageY - os.top + viewport.y;
	});
	view.mousedown(function(event) {
		mouse.pressed = true;
		return false;
	});
	view.mouseup(function(event) {
		mouse.pressed = false;
	});
	view.get().onselectstart = function () { return false; }
	
	viewport = new jaws.Viewport({});
	
	tileset = new jaws.SpriteSheet({image: "tiles.png", frame_size: [16, 16], orientation: 'down'});
	tiles = new jaws.SpriteList();
	tilemap = new jaws.TileMap({
		cell_size: [16, 16],
		size: [40, 23]
	});
	
	for (y = 0; y < 23; y++) {
		for (x = 0; x < 40; x++) {
			tiles.push(new jaws.Sprite({image: tileset.frames[2], x: x * 16, y: y * 16}));
		}
	}
	
	tilemap.push(tiles);
  }

  this.update = function() {
	elapsed = jaws.gameloop.tick_duration / 1000.0;
    
	spd = 100;
	move = {x: 0, y: 0};
	
	if(jaws.pressed("left") || jaws.pressed("a"))  { move.x -= 1 }
	if(jaws.pressed("right") || jaws.pressed("d")) { move.x += 1 }
	if(jaws.pressed("up") || jaws.pressed("w"))    { move.y -= 1 }
	if(jaws.pressed("down") || jaws.pressed("s"))  { move.y += 1 }
	
	mlength = Math.sqrt((move.y * move.y) + (move.x * move.x))
	if (mlength != 0) {
		move.x = move.x / mlength;
		move.y = move.y / mlength;
	}
	viewport.x += move.x * spd * elapsed;
	viewport.y += move.y * spd * elapsed;
	
	if(jaws.pressed("space")) { 
	  if(player.can_fire) {
		bullets.push( new Bullet(player.rect().right, player.y) )
		player.can_fire = false
		setTimeout(function() { player.can_fire = true }, 100)
	  }
	}

	fps.innerHTML = mouse.x + ', ' + mouse.y;
		
	if (mouse.pressed) {
		sprite = (tilemap.at(mouse.x, mouse.y))[0];
		sprite.setImage(tileset.frames[1]);
	}
	forceInsideCanvas(player)
	bullets.deleteIf(isOutsideCanvas) // delete items for which isOutsideCanvas(item) is true
	//fps.innerHTML = elapsed;
  }

  this.draw = function() {
    jaws.context.fillStyle = '#88AAFF';
	jaws.context.fillRect(0,0,jaws.width,jaws.height)
	viewport.apply( function() {
		tiles.draw()
		player.draw()
		bullets.draw()  // will call draw() on all items in the list
	});
  }

  /* Simular to example1 but now we're using jaws properties to get width and height of canvas instead */
  /* This mainly since we let jaws handle the canvas now */
  function isOutsideCanvas(item) { 
	return (item.x < 0 || item.y < 0 || item.x > jaws.width || item.y > jaws.height) 
  }
  function forceInsideCanvas(item) {
	if(item.x < 0)                  { item.x = 0  }
	if(item.right > jaws.width)     { item.x = jaws.width - item.width }
	if(item.y < 0)                  { item.y = 0 }
	if(item.bottom  > jaws.height)  { item.y = jaws.height - item.height }
  }

  function Bullet(x, y) {
	this.x = x
	this.y = y
	this.draw = function() {
	  this.x += 4
	  jaws.context.drawImage(jaws.assets.get("bullet.png"), this.x, this.y)
	}
  }
}

function MenuState() {
  var index = 0
  var items = ["Start", "Settings", "Highscore"]

  this.setup = function() {
	index = 0
	jaws.on_keydown(["down","s"],       function()  { index++; if(index >= items.length) {index=items.length-1} } )
	jaws.on_keydown(["up","w"],         function()  { index--; if(index < 0) {index=0} } )
	jaws.on_keydown(["enter","space"],  function()  { if(items[index]=="Start") {jaws.switchGameState(PlayState) } } )
  }

  this.draw = function() {
	jaws.context.clearRect(0,0,jaws.width,jaws.height)
	for(var i=0; items[i]; i++) {
	  // jaws.context.translate(0.5, 0.5)
	  jaws.context.font = "bold 50pt terminal";
	  jaws.context.lineWidth = 10
	  jaws.context.fillStyle =  (i == index) ? "Red" : "Black"
	  jaws.context.strokeStyle =  "rgba(200,200,200,0.0)"
	  jaws.context.fillText(items[i], 30, 100 + i * 60)
	}  
  }
}

$(window).load(function() {
	fps = document.getElementById("fps")
	jaws.assets.add("plane.png")
    jaws.assets.add("bullet.png")
    jaws.assets.add("tiles.png")
    jaws.start(MenuState, {fps: 30})
});