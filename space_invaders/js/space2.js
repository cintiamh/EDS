// Generated by CoffeeScript 1.4.0
(function() {
  var BLOCK_SIZE, BORDER, HEIGHT, HEIGHT_NUM_BLOCKS, WIDTH, WIDTH_NUM_BLOCKS, alienDownMove, alienMovPause, alienMoveDirection, alienSideMove, alienStrArr, alienWidth, aliensAnimation, aliensArr, aliensCount, aliensGroup, aliensGroupExt, aliensGroupLimits, aliensLayer, aliensWidthArr, animations, background, backgroundLayer, bulletSpeed, bulletsArr, bulletsGroup, canon, canonAnimation, canonLayer, canonSpeed, changeAlienDirection, checkAliensMinMax, checkBulletCol, imageObj, moveAliens, moveAliensBlock, moveCanon, resetAliensGroupLimits, shootNewBullet, stage, startTime;

  BLOCK_SIZE = 3;

  WIDTH_NUM_BLOCKS = 184;

  HEIGHT_NUM_BLOCKS = 191;

  WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE;

  HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE;

  BORDER = 4 * BLOCK_SIZE;

  canon = null;

  alienSideMove = 2 * BLOCK_SIZE;

  alienDownMove = 6 * BLOCK_SIZE;

  alienWidth = 12 * BLOCK_SIZE;

  alienMoveDirection = 1;

  aliensGroupLimits = {
    minX: -1,
    maxX: -1,
    minY: -1,
    maxY: -1
  };

  aliensGroupExt = {
    x: -1,
    y: -1
  };

  startTime = 0;

  aliensCount = 0;

  alienMovPause = 1;

  canonSpeed = 15;

  bulletSpeed = 15;

  alienStrArr = ['alien03', 'alien02', 'alien02', 'alien01', 'alien01'];

  aliensWidthArr = [8 * BLOCK_SIZE, 11 * BLOCK_SIZE, 11 * BLOCK_SIZE, 12 * BLOCK_SIZE, 12 * BLOCK_SIZE];

  aliensArr = [];

  bulletsArr = [];

  stage = new Kinetic.Stage({
    container: "container",
    width: WIDTH,
    height: HEIGHT
  });

  backgroundLayer = new Kinetic.Layer;

  background = new Kinetic.Rect({
    x: 0,
    y: 0,
    width: WIDTH,
    height: HEIGHT,
    fill: "#000000"
  });

  backgroundLayer.add(background);

  stage.add(backgroundLayer);

  aliensLayer = new Kinetic.Layer;

  canonLayer = new Kinetic.Layer;

  animations = {
    alien01: [
      {
        x: BLOCK_SIZE,
        y: BLOCK_SIZE,
        width: 12 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }, {
        x: 14 * BLOCK_SIZE,
        y: BLOCK_SIZE,
        width: 12 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }
    ],
    alien02: [
      {
        x: BLOCK_SIZE,
        y: 10 * BLOCK_SIZE,
        width: 11 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }, {
        x: 13 * BLOCK_SIZE,
        y: 10 * BLOCK_SIZE,
        width: 11 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }
    ],
    alien03: [
      {
        x: BLOCK_SIZE,
        y: 19 * BLOCK_SIZE,
        width: 8 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }, {
        x: 10 * BLOCK_SIZE,
        y: 19 * BLOCK_SIZE,
        width: 8 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }
    ],
    spaceship: [
      {
        x: BLOCK_SIZE,
        y: (3 * 8 + 4) * BLOCK_SIZE,
        width: 16 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }
    ],
    canon: [
      {
        x: BLOCK_SIZE,
        y: (4 * 8 + 5) * BLOCK_SIZE,
        width: 15 * BLOCK_SIZE,
        height: 8 * BLOCK_SIZE
      }
    ]
  };

  aliensGroup = new Kinetic.Group();

  bulletsGroup = new Kinetic.Group();

  imageObj = new Image();

  imageObj.src = "img/aliens_all.png";

  imageObj.onload = function() {
    var alien, num1, num2, _i, _j, _k, _len, _ref;
    canon = new Kinetic.Sprite({
      x: WIDTH / 2 - 7 * BLOCK_SIZE,
      y: HEIGHT - (8 * BLOCK_SIZE + BORDER),
      image: imageObj,
      animation: 'canon',
      animations: animations,
      frameRate: 1,
      width: 15 * BLOCK_SIZE,
      height: 8 * BLOCK_SIZE
    });
    canonLayer.add(canon);
    stage.add(canonLayer);
    canon.start();
    for (num1 = _i = 0; _i <= 4; num1 = ++_i) {
      for (num2 = _j = 0; _j <= 10; num2 = ++_j) {
        aliensGroup.add(new Kinetic.Sprite({
          x: num2 * (12 + 2) * BLOCK_SIZE,
          y: num1 * (8 + 6) * BLOCK_SIZE,
          image: imageObj,
          animation: alienStrArr[num1],
          animations: animations,
          frameRate: 2,
          width: aliensWidthArr[num1],
          height: 8 * BLOCK_SIZE,
          visible: true
        }));
      }
    }
    aliensLayer.add(aliensGroup);
    aliensGroup.setPosition(BORDER, BORDER);
    _ref = aliensGroup.getChildren();
    for (_k = 0, _len = _ref.length; _k < _len; _k++) {
      alien = _ref[_k];
      alien.start();
    }
    checkAliensMinMax();
    return stage.add(aliensLayer);
  };

  canonAnimation = new Kinetic.Animation(function(frame) {
    var bullet, _i, _len, _ref;
    if (canon) {
      document.onkeydown = function(event) {
        switch (event.keyCode) {
          case 37:
          case 65:
            return moveCanon(-canonSpeed);
          case 39:
          case 68:
            return moveCanon(canonSpeed);
          case 32:
            return shootNewBullet(canon.getPosition().x + canon.getWidth() / 2 - BLOCK_SIZE / 2, canon.getPosition().y);
        }
      };
      _ref = bulletsGroup.getChildren();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bullet = _ref[_i];
        if (bullet) {
          bullet.move(0, -bulletSpeed);
        }
      }
      return checkBulletCol();
    }
  });

  aliensAnimation = new Kinetic.Animation(function(frame) {
    if (frame.time - startTime > 500) {
      startTime = frame.time;
      return moveAliensBlock();
    }
  });

  canonAnimation.start();

  aliensAnimation.start();

  moveAliensBlock = function() {
    if ((alienMoveDirection > 0 && (aliensGroupLimits.maxX + alienWidth + aliensGroup.getX() + BORDER) >= WIDTH) || (alienMoveDirection < 0 && (aliensGroupLimits.minX + aliensGroup.getX()) <= BORDER)) {
      aliensGroup.move(0, alienDownMove);
      return changeAlienDirection();
    } else {
      return aliensGroup.move(alienSideMove * alienMoveDirection, 0);
    }
  };

  checkAliensMinMax = function() {
    var alien, _i, _len, _ref, _results;
    resetAliensGroupLimits();
    _ref = aliensGroup.getChildren();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      alien = _ref[_i];
      if (alien && alien.isVisible()) {
        if (aliensGroupLimits.minX < 0 || aliensGroupLimits.minX > alien.getX()) {
          aliensGroupLimits.minX = alien.getX();
        }
        if (aliensGroupLimits.minY < 0 || aliensGroupLimits.minY > alien.getY()) {
          aliensGroupLimits.minY = alien.getY();
        }
        if (aliensGroupLimits.maxX < 0 || aliensGroupLimits.maxX < alien.getX()) {
          aliensGroupLimits.maxX = alien.getX();
        }
        if (aliensGroupLimits.maxY < 0 || aliensGroupLimits.maxY < alien.getY()) {
          _results.push(aliensGroupLimits.maxY = alien.getY());
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  resetAliensGroupLimits = function() {
    return aliensGroupLimits = {
      minX: -1,
      maxX: -1,
      minY: -1,
      maxY: -1
    };
  };

  moveAliens = function(dirX, dirY) {
    var alien, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = aliensArr.length; _i < _len; _i++) {
      alien = aliensArr[_i];
      _results.push(alien.move(dirX, dirY));
    }
    return _results;
  };

  changeAlienDirection = function() {
    return alienMoveDirection *= -1;
  };

  moveCanon = function(speed) {
    if (speed < 0 && canon.getPosition().x > BORDER * 2) {
      canon.move(speed, 0);
    }
    if (speed > 0 && canon.getPosition().x < WIDTH - BORDER - 15 * BLOCK_SIZE) {
      return canon.move(speed, 0);
    }
  };

  shootNewBullet = function(x, y) {
    bulletsGroup.add(new Kinetic.Rect({
      x: x,
      y: y,
      width: BLOCK_SIZE,
      height: 4 * BLOCK_SIZE,
      fill: "#FFCCCC"
    }));
    return canonLayer.add(bulletsGroup);
  };

  checkBulletCol = function() {
    var alien, bullet, index, _i, _len, _ref, _results;
    index = 0;
    _ref = bulletsGroup.getChildren();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      bullet = _ref[_i];
      if (bullet && bullet.getPosition().y < -BORDER) {
        _results.push(bullet.destroy());
      } else if (bullet) {
        _results.push((function() {
          var _j, _len1, _ref1, _results1;
          _ref1 = aliensGroup.getChildren();
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            alien = _ref1[_j];
            if (bullet.getX() > alien.getX() && bullet.getX() + BLOCK_SIZE < alien.getX() + alien.getWidth()) {
              if (bullet.getY() > alien.getY() && bullet.getY() + 4 * BLOCK_SIZE < alien.getY() + alien.getHeight()) {
                alien.destroy();
                checkAliensMinMax();
                bullet.destroy();
                break;
              } else {
                _results1.push(void 0);
              }
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        })());
      } else {
        _results.push(index++);
      }
    }
    return _results;
  };

  /*
  removeBulletFromArray = (index) ->
    bullet = bulletsArr[index]
    bulletsArr.splice(index, 1)
    bullet.remove()
  */


}).call(this);
