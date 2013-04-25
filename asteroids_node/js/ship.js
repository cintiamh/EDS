// Generated by CoffeeScript 1.6.2
(function() {
  Game.Ship = (function() {
    function Ship(x, y, imageObj) {
      var animations;

      this.x = x;
      this.y = y;
      this.imageObj = imageObj;
      animations = {
        idle: [
          {
            x: 3,
            y: 12,
            width: 80,
            height: 65
          }
        ],
        thrust: [
          {
            x: 95,
            y: 12,
            width: 80,
            height: 65
          }
        ]
      };
      this.ship_obj = new Kinetic.Sprite({
        x: this.x,
        y: this.y,
        image: imageObj,
        animation: 'idle',
        animations: animations,
        frameRate: 7,
        index: 0
      });
      this.ship_obj.setOffset(40, 30);
      this.velocity = {
        x: 0,
        y: 0
      };
      this.acceleration = 0;
      this.rotation = 0;
      this.bullets = [];
      this.rocks = [];
    }

    Ship.prototype.setThrust = function() {
      return this.ship_obj.setAnimation('thrust');
    };

    Ship.prototype.endThrust = function() {
      return this.ship_obj.setAnimation('idle');
    };

    Ship.prototype.setAcceleration = function(val) {
      this.acceleration += val;
      return this.setThrust();
    };

    Ship.prototype.setRotation = function(val) {
      return this.rotation = val;
    };

    Ship.prototype.getHypotenuse = function(x, y) {
      return Math.sqrt(x * x + y * y);
    };

    Ship.prototype.rotate = function(frame) {
      var angleDiff, angularSpeed;

      angularSpeed = Math.PI / 2;
      angleDiff = frame.timeDiff * angularSpeed / 1000;
      return this.ship_obj.rotate(this.rotation * angleDiff);
    };

    Ship.prototype.moveShip = function() {
      var movementAngle, speed, speedAngle;

      if (this.acceleration !== 0) {
        movementAngle = this.ship_obj.getRotation();
        this.velocity.x += Math.cos(movementAngle) * this.acceleration;
        this.velocity.y += Math.sin(movementAngle) * this.acceleration;
        this.acceleration = 0;
      }
      speed = this.getHypotenuse(this.velocity.x, this.velocity.y);
      if (speed > Game.SHIP_MAX_VEL) {
        speed = Game.SHIP_MAX_VEL;
      } else if (speed > 0) {
        speed -= Game.SHIP_DRAG;
      }
      speedAngle = Math.atan2(this.velocity.y, this.velocity.x);
      this.velocity.x = Math.cos(speedAngle) * speed;
      this.velocity.y = Math.sin(speedAngle) * speed;
      return this.ship_obj.move(this.velocity.x, this.velocity.y);
    };

    Ship.prototype.fixPosition = function() {
      if (this.ship_obj.getX() <= 0) {
        this.ship_obj.setX(Game.WIDTH);
      } else if (this.ship_obj.getX() >= Game.WIDTH) {
        this.ship_obj.setX(0);
      }
      if (this.ship_obj.getY() <= 0) {
        return this.ship_obj.setY(Game.HEIGHT);
      } else if (this.ship_obj.getY() >= Game.HEIGHT) {
        return this.ship_obj.setY(0);
      }
    };

    Ship.prototype.createBullet = function(layer) {
      var bullet;

      bullet = new Kinetic.Rect({
        x: this.ship_obj.getX(),
        y: this.ship_obj.getY(),
        width: 8,
        height: 4,
        fill: '#00FFFF'
      });
      bullet.setRotation(this.ship_obj.getRotation());
      bullet.move(Math.cos(this.ship_obj.getRotation()) * 40, Math.sin(this.ship_obj.getRotation()) * 40);
      layer.add(bullet);
      return this.bullets.push(bullet);
    };

    Ship.prototype.moveBullets = function() {
      var bullet, _i, _len, _ref, _results;

      _ref = this.bullets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bullet = _ref[_i];
        if (bullet) {
          _results.push(bullet.move(Math.cos(bullet.getRotation()) * Game.BULLET_SPEED, Math.sin(bullet.getRotation()) * Game.BULLET_SPEED));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Ship.prototype.checkBullets = function() {
      var bullet, _i, _len, _ref, _results;

      _ref = this.bullets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bullet = _ref[_i];
        if (bullet && this.isBulletOutside(bullet)) {
          this.bullets.splice(this.bullets.indexOf(bullet), 1);
          _results.push(bullet.destroy());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Ship.prototype.isBulletOutside = function(bullet) {
      if (bullet.getX() < 0 || bullet.getX() > Game.WIDTH) {
        return true;
      }
      if (bullet.getY() < 0 || bullet.getY() > Game.HEIGHT) {
        return true;
      }
      return false;
    };

    return Ship;

  })();

}).call(this);
