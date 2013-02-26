// Generated by CoffeeScript 1.4.0
(function() {
  var BLOCK_SIZE, BORDER, Bullet, HEIGHT, HEIGHT_NUM_BLOCKS, WIDTH, WIDTH_NUM_BLOCKS, alienDownMove, alienMovPause, alienMoveDirection, alienSideMove, alienStrArr, alienWidth, aliensAnimation, aliensCount, aliensGroup, aliensGroupEndPos, aliensGroupExt, aliensGroupStartPos, aliensLayer, animations, background, backgroundLayer, bulletSpeed, bulletsArr, bulletsGroup, canon, canonAnimation, canonLayer, canonSpeed, changeAlienDirection, imageObj, moveAliensBlock, moveCanon, shootNewBullet, stage, startTime;

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

  aliensGroupStartPos = {
    x: -1,
    y: -1
  };

  aliensGroupEndPos = {
    x: -1,
    y: -1
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
      frameRate: 1
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
          frameRate: 2
        }));
      }
    }
    aliensLayer.add(aliensGroup);
    aliensGroup.setPosition(BORDER, BORDER);
    _ref = aliensGroup.getChildren();
    for (_k = 0, _len = _ref.length; _k < _len; _k++) {
      alien = _ref[_k];
      console.log(alien.getPosition());
      alien.start();
    }
    return stage.add(aliensLayer);
  };

  canonAnimation = new Kinetic.Animation(function(frame) {
    var bullet, _i, _len, _results;
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
            console.log("pew");
            return shootNewBullet(canon.getPosition().x, canon.getPosition().y);
        }
      };
      _results = [];
      for (_i = 0, _len = bulletsArr.length; _i < _len; _i++) {
        bullet = bulletsArr[_i];
        _results.push(bullet.move(0, -bulletSpeed));
      }
      return _results;
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
    var alien, _i, _len, _ref;
    _ref = aliensGroup.getChildren();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      alien = _ref[_i];
      if (aliensGroupStartPos.x < 0 || aliensGroupStartPos.x > alien.getPosition().x) {
        aliensGroupStartPos.x = alien.getPosition().x;
      }
      if (aliensGroupStartPos.y < 0 || aliensGroupStartPos.y > alien.getPosition().y) {
        aliensGroupStartPos.y = alien.getPosition().y;
      }
      if (aliensGroupEndPos.x < 0 || aliensGroupEndPos.x < alien.getPosition().x) {
        aliensGroupEndPos.x = alien.getPosition().x;
      }
      if (aliensGroupEndPos.y < 0 || aliensGroupEndPos.y < alien.getPosition().y) {
        aliensGroupEndPos.y = alien.getPosition().y;
      }
    }
    if ((alienMoveDirection > 0 && (aliensGroupEndPos.x + alienWidth + aliensGroup.getPosition().x + BORDER) >= WIDTH) || (alienMoveDirection < 0 && (aliensGroupStartPos.x + aliensGroup.getPosition().x) <= BORDER)) {
      aliensGroup.move(0, alienDownMove);
      return changeAlienDirection();
    } else {
      return aliensGroup.move(alienSideMove * alienMoveDirection, 0);
    }
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
    var bullet;
    bullet = new Kinetic.Rect({
      x: x,
      y: y,
      width: BLOCK_SIZE,
      height: 4 * BLOCK_SIZE,
      fill: "#FFCCCC"
    });
    bulletsArr.push(bullet);
    return canonLayer.add(bullet);
  };

  Bullet = (function() {

    function Bullet(x, y) {
      this.x = x;
      this.y = y;
      this.bullet = new Kinetic.Rect({
        x: this.x,
        y: this.y,
        width: BLOCK_SIZE,
        height: 4 * BLOCK_SIZE,
        fill: "#FFCCCC"
      });
      canonLayer.add(this.bullet);
      bulletsArr.push(this.bullet);
      this.index = bulletsArr.length - 1;
    }

    Bullet.prototype.move = function(speed) {
      if (this.bullet) {
        return this.bullet.move(0, speed);
      }
    };

    Bullet.prototype.checkAlienCol = function() {
      var alien, _i, _len, _ref, _results;
      _ref = aliensGroup.getChildren();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        alien = _ref[_i];
        if ((this.bullet.getPosition().x > alien.getPosition().x + aliensGroup.getPosition().x) && (this.bullet.getPosition().x < alien.getPosition().x + aliensGroup.getPosition().x + 12 * BLOCK_SIZE)) {
          if ((this.bullet.getPosition().y > alien.getPosition().y + aliensGroup.getPosition().y) && (this.bullet.getPosition().y < alien.getPosition().y + aliensGroup.getPosition().y + 8 * BLOCK_SIZE)) {
            alien.remove();
            this.bullet.remove();
            break;
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return Bullet;

  })();

}).call(this);
