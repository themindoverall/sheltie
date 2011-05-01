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
	
	if (leveldata !== undefined) {
		my.loadLevel(leveldata);
	}
  }

  this.update = function() {
	if (mouse.pressed && !mouse.lastPressed) {
		mouse.justPressed = true;
	} else {
		mouse.justPressed = false;
	}
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
		if (mouse.justPressed) {
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
		if (mouse.justPressed) {
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
		if (mouse.justPressed) {
			my.selectedsprite = undefined;
			$.each(objects, function(i, obj) {
				if (parseInt(mouse.x / 16) == obj.pos[0] && parseInt(mouse.y / 16) == obj.pos[1]) {
					my.selectedsprite = obj;
					return false;
				}
			});
			view.trigger('obj-sel', my.selectedsprite);
		}
	}
	
	mouse.lastPressed = mouse.pressed;
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
		if (my.selectedsprite != null) {
			jaws.context.strokeStyle = '#00FF00'
			jaws.context.strokeRect(my.selectedsprite.x, my.selectedsprite.y, my.selectedsprite.width, my.selectedsprite.height)
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
	
	this.getObjects = function() {
		return objects;
	}
	
	this.loadLevel = function(level) {
		w = parseInt(level.width)
		h = parseInt(level.height)
		
		rows = level.map.split('\n');
		$.each(rows, function (y, row) {
			$.each(row.split(', '), function(x, frame) {
				if (!frame.match(/^\d+$/)) {
					return true; //continue
				}
				sprite = (my.tilemap.cell(x, y))[0];
				sprite.setImage(tileset.frames[frame]);
				sprite.frameid = frame;
			});
		});
		
		libstoload = {}
		$.each(level.objects, function(i, objdef) {
			libstoload[objdef.lib] = 1;
		});
		mytoload = 0;
		$.each(libstoload, function(i, j) {
			mytoload++;
		})
		
		function loadsprites() {
			$.each(level.objects, function(i, objdef) {
				libobj = my.libraries[objdef.lib][objdef.obj];
				
				ss = new jaws.SpriteSheet({image: "images/" + libobj.image.src, frame_size: [libobj.image.width, libobj.image.height], orientation: 'down'})
				sprite = new jaws.Sprite({
					image: ss.frames[parseInt(libobj.image.frame)],
					x: parseInt(objdef.pos[0]) * 16,
					y: parseInt(objdef.pos[1]) * 16
				})
				objects.push(sprite)
				sprite.props = objdef.props;
				sprite.obj = libobj;
				sprite.pos = objdef.pos;
			});
		}
		
		$.each(libstoload, function(lib, v) {
			loadLibrary(lib, { 'lib': function(lib) {
				lib.onload = function() {
					mytoload--;
					console.log('toload = ' + mytoload)
					if (mytoload == 0) {
						loadsprites();
					}
				}}
			});
		});
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

function loadLibrary(libname, afters) {
	if (jaws.game_state.libraries[libname] !== undefined) {
		lib = jaws.game_state.libraries[libname];
		afters['lib'] && afters['lib'](lib);
		lib.onload && lib.onload();
		return;
	}
	
	$.ajax('load_objects/' + libname + '?' + Math.floor(Math.random()*100000), 
	{
		success: function(data, textStatus, jqXHR) {
			$("#objects").html("")
			lib = {}
			assetstoload = []
			toload = 0;
			$.each(data, function(i, obj) {
				img = obj.image;
				obj.lib = libname;
				
				assetstoload.push("images/" + img.src);
				toload++;
				
				lib[obj.name] = obj
				afters['obj'] && afters['obj'](obj);
			})
						
			jaws.game_state.libraries[libname] = lib;
			afters['lib'] && afters['lib'](lib);
			
			$.each(assetstoload, function(i, src) {
				jaws.assets.getOrLoad(src, function(){
					toload--;
					if (toload == 0) {
						lib.onload && lib.onload()
					}
				});
			});
		},
		error: function(qXHR, textStatus, errorThrown) {
			alert(textStatus);
		}
	});
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
		
		objs = {}
		objsprites = jaws.game_state.getObjects();
		$.each(objsprites, function (i, sprite) {
			objs[sprite.props['name']] = {
				lib: sprite.obj.lib,
				obj: sprite.obj.name,
				props: sprite.props,
				pos: sprite.pos
			}
		});
		
		$.post('save/' + filename, {
			filename: filename,
			level: {
				name: filename,
				width: tm.size[0],
				height: tm.size[1],
				tileset: (tm.cell(0,0))[0].image.src,
				map: mapstr,
				objects: objs
			}
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
		loadLibrary(libname, {'obj': function(obj) {
			$("#objects").append("<option>" + obj.name + "</option>");
		}});
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
		refreshProps(obj);
	});
	
	$("#obj-props").change(function() {
		obj = $(this).data('obj');
		propkey = $(this).val();
		$("#prop-key").val(propkey);
		$("#prop-val").val(obj.props[propkey]);
	});
	
	$("#prop-set").click(function() {
		obj = $("#obj-props").data('obj');
		propkey = $("#prop-key").val();
		propval = $("#prop-val").val();
		
		if (propkey == '') {
			return;
		}
		if (propval == '') {
			delete obj.props[propkey]
		} else {
			obj.props[propkey] = propval;
		}
		
		refreshProps(obj);
	});
	
	function refreshProps(obj) {
		$("#prop-key").val('');
		$("#prop-val").val('');
		
		if (obj === undefined) {
			$("#obj-props").html("");
			return;
		}
		$("#obj-props").data('obj', obj);
		propopts = '';
		$.each(obj.props, function(key, val) {
			propopts += '<option value="' + key + '">' + key + '=' + val + '</option>'
		});
		$("#obj-props").html(propopts)
	}
});

$(window).load(function() {
	fps = document.getElementById("fps")
	jaws.assets.root = "images/";
	jaws.assets.add(["tiles.png"])
    jaws.start(PlayState, {fps: 20})
});