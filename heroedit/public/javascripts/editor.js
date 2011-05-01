var fps = null
function PlayState() {
  var view = $('#view');
  var tiles;
  var tileset;
  var mouse = {lastPressed: false};
  var viewport;
  var tileselect;
  var curframe = 1;
  var curobject = null;
  var objects;
  var my = this;
  var curtool = "tile";
  var selectedsprite;

  this.setup = function() {
	my.libraries = []
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
	
	tileset = new jaws.SpriteSheet({image: "images/tiles.png", frame_size: [16, 16], orientation: 'down'});
	tiles = new jaws.SpriteList();
	objects = new jaws.SpriteList();
	
	tileselect = new TileSelect(tileset);
	
	my.tilemap = new jaws.TileMap({
		cell_size: [16, 16],
		size: [32, 32]
	});
	
	for (y = 0; y < my.tilemap.size[1]; y++) {
		for (x = 0; x < my.tilemap.size[0]; x++) {
			spt = new jaws.Sprite({image: tileset.frames[2], x: x * 16, y: y * 16});
			spt.frameid = 2;
			tiles.push(spt);
		}
	}
	
	my.tilemap.push(tiles);
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
	
	if (curtool == 'tile') {
		if (mouse.pressed) {
			sprite = (my.tilemap.at(mouse.x, mouse.y))[0];
			sprite.setImage(tileset.frames[curframe]);
			sprite.frameid = curframe;
		}
	} else if (curtool == 'obj') {
		if (mouse.pressed) {
			ss = new jaws.SpriteSheet({image: "images/" + curobject.image.src, frame_size: [curobject.image.width, curobject.image.height], orientation: 'down'})
			console.log(ss.image)
			sprite = new jaws.Sprite({
				image: ss.frames[parseInt(curobject.image.frame)],
				x: parseInt(mouse.x / 16) * 16,
				y: parseInt(mouse.y / 16) * 16
			})
			objects.push(sprite)
			sprite.props = {name: "obj" + objects.length};
			sprite.obj = curobject;
			sprite.pos = [parseInt(mouse.x / 16), parseInt(mouse.y / 16)];
		}
	} else if (curtool == 'del') {
		if (mouse.pressed) {
			bad = undefined;
			$.each(objects, function(i, obj) {
				if (parseInt(mouse.x / 16) == obj.pos[0] && parseInt(mouse.y / 16) == obj.pos[1]) {
					bad = obj;
					return false;
				}
			});
			objects.remove(bad);
		}
	} else if (curtool == 'sel') {
		if (mouse.pressed) {
			selectedsprite = undefined;
			$.each(objects, function(i, obj) {
				if (parseInt(mouse.x / 16) == obj.pos[0] && parseInt(mouse.y / 16) == obj.pos[1]) {
					selectedsprite = obj;
					return false;
				}
			});
			view.trigger('obj-sel', selectedsprite);
		}
	}
	//fps.innerHTML = mouse.x + ', ' + mouse.y;
	//fps.innerHTML = elapsed;
	fps.innerHTML = jaws.gameloop.fps;
  }

  this.draw = function() {
    jaws.context.fillStyle = '#88AAFF';
	jaws.context.fillRect(0,0,jaws.width,jaws.height)
	viewport.apply( function() {
		tiles.draw()
		objects.draw()
		if (selectedsprite != null) {
			jaws.context.strokeStyle = '#00FF00'
			jaws.context.strokeRect(selectedsprite.x, selectedsprite.y, selectedsprite.width, selectedsprite.height)
		}
	});
  }

  function Bullet(x, y) {
	this.x = x
	this.y = y
	this.draw = function() {
	  this.x += 4
	  jaws.context.drawImage(jaws.assets.get("images/bullet.png"), this.x, this.y)
	}
  }

	function TileSelect(tileset) {
		this.selector = $("#tile-select");
		data = '<img width="' + (tileset.image.width * 2) + '" src="' + tileset.image.src + '" usemap="#sil" /><map id="sil" name="sil">';
		for(var y=0; y * 16 < tileset.image.height; y++) {
			for(var x=0; x * 16 < tileset.image.width; x++) {
				data += '<area class="tile-frame" data-frameid="' + ((y * (tileset.image.width / 16)) + x) + '" href="javascript:void(0);" coords="' + ((x + 1) * 16 * 2) + ',' + ((y) * 16 * 2) + ',' + ((x) * 16 * 2) + ',' + ((y + 1) * 16 * 2) + '" />';
			}
		}
		data += '</map>';
		
		this.selector.html(data);
		$(".tile-frame").click(function() {
			curframe = parseInt($(this).attr('data-frameid'));
			console.log(curframe)
		});
	}
	
	this.setObject = function(lib, obj) {
		curobject = my.libraries[lib][obj];
	};
	
	this.setTool = function(tool) {
		curtool = tool;
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

$(document).ready(function() {
	$("div[id$='-select']").hide();
	$("#tile-select").show();
	$('#save-btn').click(function() {
		tm = jaws.game_state.tilemap;
		mapstr = '';
		for (y = 0; y < tm.size[1]; y++) {
			for (x = 0; x < tm.size[0]; x++) {
				mapstr += (tm.cell(x, y))[0].frameid + ', ';
			}
			mapstr += '\n'
		}
		filename = $('#filename').val();
		
		$.post('save/' + filename, {
			filename: filename,
			width: tm.size[0],
			height: tm.size[1],
			tileset: (tm.cell(0,0))[0].image.src,
			map: mapstr
		}, function(data) {
			jaws.log('Response: ' + data);
		});
		console.log(mapstr);
	});
	
	$("#libraries").change(function() {
		libname = $(this).val()
		if (libname === undefined) {
			return;
		}
		$.ajax('load_objects/' + libname + '?' + Math.floor(Math.random()*100000), 
		{
			success: function(data, textStatus, jqXHR) {
				$("#objects").html("")
				lib = {}
				$.each(data, function(i, obj) {
					img = obj.image;
					jaws.assets.load("images/" + img.src);
					lib[obj.name] = obj
					$("#objects").append("<option>" + obj.name + "</option>")
				})
				jaws.game_state.libraries[libname] = lib;
			},
			error: function(qXHR, textStatus, errorThrown) {
				alert(textStatus);
			}
		});
	});
	
	$("#objects").change(function() {
		libname = $("#libraries").val()
		objname = $(this).val()
		if (libname === undefined || objname === undefined) {
			return;
		}
		
		jaws.game_state.setObject(libname, objname)
	});
	
	$("input[name='tool-select']").click(function() {
		newtool = $("input[name='tool-select']:checked").val();
		jaws.game_state.setTool(newtool);
		$("div[id$='-select']").hide();
		$("#" + newtool + "-select").show();
	});
	
	$("#view").bind('obj-sel', function (e, obj) {
		//$("obj-props").html("");
		propopts = '';
		$.each(obj.props, function(key, val) {
			propopts += '<option value="' + key + '">' + key + '=' + val + '</option>'
		});
		$("#obj-props").html(propopts)
	});
});

$(window).load(function() {
	fps = document.getElementById("fps")
	jaws.assets.root = "images/";
	jaws.assets.add(["tiles.png"])
    jaws.start(PlayState, {fps: 20})
});