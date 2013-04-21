// Generated by CoffeeScript 1.6.2
(function() {
  var ASPECT, BLOCK_SIZE, DEPTH, FAR, HEIGHT, MAX_DEPTH, MAX_SIDE, MIN_DEPTH, MIN_SIDE, NEAR, TABLE_DEPTH, TABLE_HEIGHT, TABLE_WIDTH, VIEW_ANGLE, WIDTH, addPoints, boundingBox, calculateExcess, camera, canShapeMove, canvas, checkCompletedLevel, checkGameOver, convertShapeToSolidBlocks, createMovingBlock, createShape, createSolidBlock, eliminateCompletedLevel, intervals, level, moveShape, moveShapeBack, points, render, renderer, rotateShape, scene, shape, shapes, static_blocks, static_colors, timer;

  BLOCK_SIZE = 100;

  TABLE_WIDTH = 7;

  TABLE_HEIGHT = 7;

  TABLE_DEPTH = 15;

  WIDTH = BLOCK_SIZE * TABLE_WIDTH;

  HEIGHT = BLOCK_SIZE * TABLE_HEIGHT;

  DEPTH = BLOCK_SIZE * TABLE_DEPTH;

  MAX_DEPTH = -0.5 * BLOCK_SIZE;

  MIN_DEPTH = -14.5 * BLOCK_SIZE;

  MAX_SIDE = 3 * BLOCK_SIZE;

  MIN_SIDE = -3 * BLOCK_SIZE;

  VIEW_ANGLE = 45;

  ASPECT = WIDTH / HEIGHT;

  NEAR = 0.1;

  FAR = 10000;

  shape = null;

  static_blocks = [];

  level = 0;

  intervals = [1000, 900, 800, 700, 600, 500, 400, 300, 200, 100];

  timer = 0;

  points = 0;

  shapes = [
    [
      {
        x: 0,
        y: -1,
        z: 0
      }, {
        x: 0,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 1,
        z: 0
      }, {
        x: 0,
        y: 2,
        z: 0
      }
    ], [
      {
        x: -1,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 0,
        z: 0
      }, {
        x: 1,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 1,
        z: 0
      }
    ], [
      {
        x: 0,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 1,
        z: 0
      }, {
        x: 1,
        y: 0,
        z: 0
      }, {
        x: 2,
        y: 0,
        z: 0
      }
    ], [
      {
        x: -1,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 0,
        z: 0
      }, {
        x: 0,
        y: 1,
        z: 0
      }, {
        x: 1,
        y: 1,
        z: 0
      }
    ], [
      {
        x: -1,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: -1,
        z: -1
      }, {
        x: 0,
        y: -1,
        z: 0
      }
    ], [
      {
        x: -1,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: 1,
        z: -1
      }, {
        x: 0,
        y: 1,
        z: 0
      }
    ], [
      {
        x: -1,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: 0,
        z: -1
      }, {
        x: 0,
        y: -1,
        z: -1
      }, {
        x: 0,
        y: 0,
        z: 0
      }
    ]
  ];

  static_colors = [0xFFFFFF, 0xC0C0C0, 0x800000, 0xFF0000, 0x800000, 0xFFFF00, 0x808000, 0x00FF00, 0x008000, 0x00FFFF, 0x008080, 0x0000FF, 0x000080, 0xFF00FF, 0x800080];

  scene = new THREE.Scene();

  camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);

  renderer = new THREE.WebGLRenderer();

  renderer.setSize(WIDTH, HEIGHT);

  canvas = $('#canvas');

  canvas.append(renderer.domElement);

  boundingBox = new THREE.Mesh(new THREE.CubeGeometry(WIDTH, HEIGHT, DEPTH * 2, TABLE_WIDTH, TABLE_HEIGHT, TABLE_DEPTH * 2), new THREE.MeshBasicMaterial({
    color: 0x999999,
    wireframe: true,
    wireframeLinewidth: 2
  }));

  scene.add(boundingBox);

  createMovingBlock = function(x, y, z) {
    var block;

    block = new THREE.SceneUtils.createMultiMaterialObject(new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), [
      new THREE.MeshBasicMaterial({
        color: 0xFFFFFF,
        wireframe: true,
        transparent: true
      }), new THREE.MeshBasicMaterial({
        color: 0xFFFFFF,
        transparent: true,
        opacity: 0.5
      })
    ]);
    scene.add(block);
    block.position.z = z * BLOCK_SIZE;
    block.position.x = x * BLOCK_SIZE;
    block.position.y = y * BLOCK_SIZE;
    return block;
  };

  createSolidBlock = function(x, y, z) {
    var block2;

    block2 = new THREE.SceneUtils.createMultiMaterialObject(new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE), [
      new THREE.MeshBasicMaterial({
        color: 0x000000,
        wireframe: true,
        transparent: true
      }), new THREE.MeshBasicMaterial({
        color: static_colors[Math.floor(Math.abs(z) / BLOCK_SIZE)]
      })
    ]);
    scene.add(block2);
    block2.position.x = x;
    block2.position.y = y;
    block2.position.z = z;
    return static_blocks.push(block2);
  };

  createShape = function() {
    var cube, random_index, _i, _len, _ref;

    random_index = Math.floor(shapes.length * Math.random());
    scene.remove(shape);
    shape = new THREE.Object3D();
    _ref = shapes[random_index];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cube = _ref[_i];
      shape.add(createMovingBlock(cube.x, cube.y, cube.z));
    }
    shape.position.z -= 0.5 * BLOCK_SIZE;
    return scene.add(shape);
  };

  moveShape = function(value_x, value_y) {
    if (canShapeMove(value_x, value_y, 0)) {
      shape.position.x = shape.position.x + value_x * BLOCK_SIZE;
      return shape.position.y = shape.position.y + value_y * BLOCK_SIZE;
    }
  };

  moveShapeBack = function() {
    if (canShapeMove(0, 0, -1)) {
      return shape.position.z = shape.position.z - BLOCK_SIZE;
    } else {
      convertShapeToSolidBlocks();
      checkCompletedLevel();
      if (checkGameOver()) {
        return console.log("Game Over");
      } else {
        return createShape();
      }
    }
  };

  canShapeMove = function(move_x, move_y, move_z) {
    var cube, pos_x, pos_y, pos_z, solid_block, _i, _len, _ref;

    _ref = shape.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cube = _ref[_i];
      pos_x = cube.position.x + shape.position.x + move_x * BLOCK_SIZE;
      pos_y = cube.position.y + shape.position.y + move_y * BLOCK_SIZE;
      pos_z = cube.position.z + shape.position.z + move_z * BLOCK_SIZE;
      solid_block = _.find(static_blocks, function(block) {
        return block.position.x === pos_x && block.position.y === pos_y && block.position.z === pos_z;
      });
      if (solid_block) {
        return false;
      } else if (pos_z < MIN_DEPTH) {
        return false;
      } else if (pos_x < MIN_SIDE || pos_x > MAX_SIDE) {
        return false;
      } else if (pos_y < MIN_SIDE || pos_y > MAX_SIDE) {
        return false;
      }
    }
    return true;
  };

  convertShapeToSolidBlocks = function() {
    var cube, _i, _len, _ref;

    _ref = shape.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cube = _ref[_i];
      createSolidBlock(cube.position.x + shape.position.x, cube.position.y + shape.position.y, cube.position.z + shape.position.z);
    }
    return scene.remove(shape);
  };

  checkGameOver = function() {
    var outbound_block;

    outbound_block = _.find(static_blocks, function(block) {
      return block.position.z > -0.5 * BLOCK_SIZE;
    });
    if (outbound_block) {
      return true;
    }
    return false;
  };

  rotateShape = function(dirx, diry, dirz) {
    var cube, temp, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;

    if (dirx !== 0) {
      _ref = shape.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cube = _ref[_i];
        temp = cube.position.y;
        cube.position.y = -1 * cube.position.z;
        cube.position.z = temp;
      }
    }
    if (diry !== 0) {
      _ref1 = shape.children;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        cube = _ref1[_j];
        temp = cube.position.x;
        cube.position.x = cube.position.z;
        cube.position.z = -1 * temp;
      }
    }
    if (dirz !== 0) {
      _ref2 = shape.children;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        cube = _ref2[_k];
        temp = cube.position.x;
        cube.position.x = -1 * cube.position.y;
        cube.position.y = temp;
      }
    }
    return calculateExcess();
  };

  calculateExcess = function() {
    var cube, excess, max_value, pos_x, pos_y, _i, _len, _ref;

    excess = {
      x: 0,
      y: 0
    };
    max_value = 3 * BLOCK_SIZE;
    _ref = shape.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cube = _ref[_i];
      pos_x = cube.position.x + shape.position.x;
      pos_y = cube.position.y + shape.position.y;
      if (Math.abs(pos_x) > max_value) {
        excess.x = Math.abs(pos_x) - max_value;
        if (pos_x > 0) {
          excess.x = -1 * excess.x;
        }
      }
      if (Math.abs(pos_y) > max_value) {
        excess.y = Math.abs(pos_y) - max_value;
        if (pos_y > 0) {
          excess.y = -1 * excess.y;
        }
      }
    }
    shape.position.x = shape.position.x + excess.x;
    return shape.position.y = shape.position.y + excess.y;
  };

  checkCompletedLevel = function() {
    var level_arr, num, num_levels, _i, _results;

    level = MIN_DEPTH / BLOCK_SIZE;
    num_levels = (MAX_DEPTH - MIN_DEPTH) / BLOCK_SIZE;
    _results = [];
    for (num = _i = 0; 0 <= num_levels ? _i <= num_levels : _i >= num_levels; num = 0 <= num_levels ? ++_i : --_i) {
      level_arr = _.filter(static_blocks, function(block) {
        if (block.position.z === level * BLOCK_SIZE) {
          return block;
        }
      });
      if (level_arr.length >= TABLE_HEIGHT * TABLE_WIDTH) {
        addPoints(50);
        _results.push(eliminateCompletedLevel(level));
      } else {
        _results.push(level = level + 1);
      }
    }
    return _results;
  };

  eliminateCompletedLevel = function(level) {
    var above_arr, cube, indexOfCube, level_arr, pos_z, _i, _j, _len, _len1, _results;

    pos_z = MIN_DEPTH - level * BLOCK_SIZE;
    level_arr = _.filter(static_blocks, function(block) {
      if (block.position.z === pos_z) {
        return block;
      }
    });
    above_arr = _.filter(static_blocks, function(block) {
      if (block.position.z > pos_z) {
        return block;
      }
    });
    for (_i = 0, _len = level_arr.length; _i < _len; _i++) {
      cube = level_arr[_i];
      indexOfCube = static_blocks.indexOf(cube);
      static_blocks.splice(indexOfCube, 1);
      scene.remove(cube);
    }
    _results = [];
    for (_j = 0, _len1 = above_arr.length; _j < _len1; _j++) {
      cube = above_arr[_j];
      cube.position.z -= BLOCK_SIZE;
      _results.push(cube.children[1].material.color.setHex(static_colors[Math.floor(Math.abs(cube.position.z) / BLOCK_SIZE)]));
    }
    return _results;
  };

  addPoints = function(n) {
    points += n;
    level = Math.floor(points / 1000);
    return document.getElementById("score").innerHTML = points;
  };

  window.$(document).ready(function() {
    return window.$(document).keydown(function(e) {
      switch (e.keyCode) {
        case 37:
          return moveShape(-1, 0);
        case 38:
          return moveShape(0, 1);
        case 39:
          return moveShape(1, 0);
        case 40:
          return moveShape(0, -1);
        case 32:
          return moveShapeBack();
        case 81:
          return rotateShape(1, 0, 0);
        case 87:
          return rotateShape(0, 1, 0);
        case 69:
          return rotateShape(0, 0, 1);
        case 65:
          return rotateShape(-1, 0, 0);
        case 83:
          return rotateShape(0, -1, 0);
        case 68:
          return rotateShape(0, 0, -1);
      }
    });
  });

  camera.position.z = DEPTH - 54 - BLOCK_SIZE * 6;

  render = function() {
    requestAnimationFrame(render);
    return renderer.render(scene, camera);
  };

  createShape();

  render();

  if (!checkGameOver()) {
    setInterval(moveShapeBack, intervals[level]);
    /*
    for num1 in [-3..3]
    for num2 in [-3..3]
      createSolidBlock(num1 * BLOCK_SIZE, num2 * BLOCK_SIZE, -14.5 * BLOCK_SIZE)
    
    for num1 in [-3..3]
    for num2 in [-3..3]
      createSolidBlock(num1 * BLOCK_SIZE, num2 * BLOCK_SIZE, -13.5 * BLOCK_SIZE)
    */

  }

}).call(this);
