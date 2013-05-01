// Generated by CoffeeScript 1.6.2
(function() {
  var BLOCK_SIZE, BORDER, HEIGHT, HEIGHT_BLOCKS, WIDTH, WIDTH_BLOCKS, alienMovPause, alienStrArr, aliensAnimation, aliensArr, aliensDirection, aliensDownMove, aliensLayer, aliensSideMove, aliensWidthArr, animateAliens, animations, background, backgroundLayer, bullet_vel, bulletsAnimation, bulletsArr, canon, canon_vel, checkAliensGoDown, checkBulletCol, checkBulletsOut, checkGameOver, explosion, explosionAnim, explosionImg, game_over, imageObj, moveAliens, moveCanon, removeAlien, removeBullet, shootBullet, stage, start_time;

  BLOCK_SIZE = 3;

  WIDTH_BLOCKS = 184;

  HEIGHT_BLOCKS = 191;

  WIDTH = WIDTH_BLOCKS * BLOCK_SIZE;

  HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE;

  BORDER = 4 * BLOCK_SIZE;

  canon = null;

  explosion = null;

  aliensArr = [];

  bulletsArr = [];

  canon_vel = 15;

  bullet_vel = 5;

  aliensDirection = 1;

  alienMovPause = 500;

  aliensSideMove = 2 * BLOCK_SIZE;

  aliensDownMove = 6 * BLOCK_SIZE;

  alienStrArr = ['alien03', 'alien02', 'alien02', 'alien01', 'alien01'];

  aliensWidthArr = [8 * BLOCK_SIZE, 11 * BLOCK_SIZE, 11 * BLOCK_SIZE, 12 * BLOCK_SIZE, 12 * BLOCK_SIZE];

  start_time = 0;

  game_over = false;

  stage = new Kinetic.Stage({
    container: "container",
    width: WIDTH,
    height: HEIGHT
  });

  backgroundLayer = new Kinetic.Layer;

  aliensLayer = new Kinetic.Layer;

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

  explosionAnim = {
    idle: [
      {
        x: 0,
        y: 0,
        width: 0,
        height: 0
      }
    ],
    explosion: [
      {
        x: 5,
        y: 3,
        width: 32,
        height: 33
      }, {
        x: 42,
        y: 3,
        width: 30,
        height: 33
      }, {
        x: 79,
        y: 3,
        width: 33,
        height: 33
      }, {
        x: 121,
        y: 3,
        width: 33,
        height: 33
      }
    ]
  };

  background = new Kinetic.Rect({
    x: 0,
    y: 0,
    width: WIDTH,
    height: HEIGHT,
    fill: "#000000"
  });

  backgroundLayer.add(background);

  stage.add(backgroundLayer);

  imageObj = new Image();

  imageObj.src = "images/aliens_all.png";

  imageObj.onload = function() {
    var new_alien, num1, num2, _i, _j;

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
    aliensLayer.add(canon);
    stage.add(aliensLayer);
    canon.start();
    for (num1 = _i = 0; _i <= 4; num1 = ++_i) {
      for (num2 = _j = 0; _j <= 10; num2 = ++_j) {
        new_alien = new Kinetic.Sprite({
          x: num2 * (12 + 2) * BLOCK_SIZE,
          y: num1 * (8 + 6) * BLOCK_SIZE,
          image: imageObj,
          animation: alienStrArr[num1],
          animations: animations,
          frameRate: 2,
          width: aliensWidthArr[num1],
          height: 8 * BLOCK_SIZE
        });
        aliensLayer.add(new_alien);
        new_alien.start();
        aliensArr.push(new_alien);
      }
    }
    return moveAliens(BORDER, BORDER);
  };

  explosionImg = new Image();

  explosionImg.src = "images/explosion.png";

  explosionImg.onload = function() {
    explosion = new Kinetic.Sprite({
      x: WIDTH,
      y: HEIGHT,
      image: explosionImg,
      animation: 'idle',
      animations: explosionAnim,
      frameRate: 4
    });
    aliensLayer.add(explosion);
    return explosion.start();
  };

  document.onkeydown = function(event) {
    switch (event.keyCode) {
      case 37:
      case 65:
        moveCanon(-1);
        break;
      case 39:
      case 68:
        moveCanon(1);
        break;
      case 32:
        shootBullet();
    }
    return event.preventDefault();
  };

  moveCanon = function(direction) {
    var next_pos, speed;

    speed = direction * canon_vel;
    next_pos = canon.getX() + speed;
    if (next_pos > BORDER && next_pos < (WIDTH - (15 * BLOCK_SIZE + BORDER))) {
      return canon.move(speed, 0);
    }
  };

  shootBullet = function() {
    var bullet;

    bullet = new Kinetic.Rect({
      x: canon.getX() + canon.getWidth() / 2 - 1,
      y: canon.getY() - canon.getHeight() / 2,
      width: BLOCK_SIZE,
      height: 4 * BLOCK_SIZE,
      fill: "#FFCCCC"
    });
    aliensLayer.add(bullet);
    return bulletsArr.push(bullet);
  };

  checkBulletsOut = function() {
    var bullet, _i, _len, _results;

    _results = [];
    for (_i = 0, _len = bulletsArr.length; _i < _len; _i++) {
      bullet = bulletsArr[_i];
      if (bullet && bullet.getY() < 0) {
        _results.push(removeBullet(bullet));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  removeBullet = function(bullet) {
    var index;

    if (bullet) {
      index = bulletsArr.indexOf(bullet);
      bullet.destroy();
      return bulletsArr.splice(index, 1);
    }
  };

  bulletsAnimation = new Kinetic.Animation(function(frame) {
    var bullet, _i, _len, _results;

    checkBulletsOut();
    _results = [];
    for (_i = 0, _len = bulletsArr.length; _i < _len; _i++) {
      bullet = bulletsArr[_i];
      if (bullet) {
        checkBulletCol(bullet);
        _results.push(bullet.move(0, -bullet_vel));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  });

  bulletsAnimation.start();

  moveAliens = function(x, y) {
    return _.each(aliensArr, function(alien) {
      return alien.move(x, y);
    });
  };

  removeAlien = function(alien) {
    var index;

    if (alien) {
      index = aliensArr.indexOf(alien);
      alien.destroy();
      aliensArr.splice(index, 1);
      return alienMovPause -= 10;
    }
  };

  checkAliensGoDown = function() {
    var go_down;

    go_down = false;
    _.each(aliensArr, function(alien) {
      var next_pos;

      next_pos = alien.getX() + aliensDirection * aliensSideMove;
      if (next_pos < BORDER || next_pos + 12 * BLOCK_SIZE > WIDTH - BORDER) {
        return go_down = true;
      }
    });
    return go_down;
  };

  animateAliens = function() {
    if (checkAliensGoDown()) {
      aliensDirection = -1 * aliensDirection;
      return moveAliens(0, aliensDownMove);
    } else {
      return moveAliens(aliensSideMove * aliensDirection, 0);
    }
  };

  checkBulletCol = function(bullet) {
    return _.each(aliensArr, function(alien) {
      var alien_x_max, alien_x_min, alien_y_max, alien_y_min, bullet_x, bullet_y;

      bullet_x = bullet.getX();
      bullet_y = bullet.getY();
      alien_x_min = alien.getX();
      alien_y_min = alien.getY();
      alien_x_max = alien_x_min + alien.getWidth();
      alien_y_max = alien_y_min + alien.getHeight();
      if (bullet_x > alien_x_min && bullet_x < alien_x_max && bullet_y > alien_y_min && bullet_y < alien_y_max) {
        explosion.setPosition(alien_x_min, alien_y_min);
        explosion.setAnimation("explosion");
        explosion.afterFrame(1, function() {
          return explosion.setAnimation("idle");
        });
        removeAlien(alien);
        return removeBullet(bullet);
      }
    });
  };

  aliensAnimation = new Kinetic.Animation(function(frame) {
    if (game_over) {
      aliensAnimation.stop();
    }
    if (start_time === 0 || frame.time - start_time > alienMovPause) {
      animateAliens();
      return start_time = frame.time;
    }
  });

  aliensAnimation.start();

  checkGameOver = function() {
    return _.each(aliensArr, function(alien) {
      var alien_x_max, alien_x_min, alien_y_max, alien_y_min, canon_x, canon_y;

      canon_x = canon.getX();
      canon_y = canon.getY();
      alien_x_min = alien.getX();
      alien_y_min = alien.getY();
      alien_x_max = alien_x_min + alien.getWidth();
      alien_y_max = alien_y_min + alien.getHeight();
      if (canon_x + canon.getWidth() > alien_x_min && canon_x < alien_x_max && canon_y + canon.getHeight() > alien_y_min && canon_y < alien_y_max) {
        return game_over = true;
      } else if (alien_y_max > HEIGHT) {
        return game_over = true;
      }
    });
  };

}).call(this);
