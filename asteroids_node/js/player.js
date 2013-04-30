// Generated by CoffeeScript 1.6.2
(function() {
  var game, rocks_arr, ship;

  window.Game = {
    WIDTH: 800,
    HEIGHT: 600,
    NUM_STARS: 200,
    SHIP_MAX_VEL: 4,
    SHIP_DRAG: 0.01,
    BULLET_SPEED: 5,
    ROCK_SPEED: 2
  };

  ship = null;

  game = null;

  rocks_arr = [];

  document.onkeydown = function(event) {
    switch (event.keyCode) {
      case 37:
      case 65:
        ship.setRotation(-1);
        break;
      case 38:
      case 87:
        ship.setAcceleration(.2);
        break;
      case 39:
      case 68:
        ship.setRotation(1);
        break;
      case 40:
      case 83:
        console.log('down');
        break;
      case 32:
        ship.createBullet(game.shipLayer);
        break;
      default:
        ship.endThrust();
    }
    return event.preventDefault();
  };

  document.onkeyup = function(event) {
    switch (event.keyCode) {
      case 38:
      case 87:
        return ship.endThrust();
      case 37:
      case 65:
        return ship.setRotation(0);
      case 39:
      case 68:
        return ship.setRotation(0);
    }
  };

  window.onload = function() {
    var anim_loop, imageObj, rockImage;

    imageObj = new Image();
    imageObj.src = 'images/double_ship.png';
    game = new Game.Main(Game.WIDTH, Game.HEIGHT);
    game.createBackground();
    game.createStars(Game.NUM_STARS);
    game.start();
    imageObj.onload = function() {
      ship = new Game.Ship(Game.WIDTH / 2, Game.HEIGHT / 2, imageObj);
      game.shipLayer.add(ship.ship_obj);
      ship.ship_obj.start();
      return console.log(ship.ship_obj.getOffset());
    };
    rockImage = new Image();
    rockImage.src = 'images/asteroid_blue.png';
    rockImage.onload = function() {
      var rock;

      rock = new Game.Rock(50, 50, rockImage);
      rock.rock_obj.setAnimation('idle');
      game.shipLayer.add(rock.rock_obj);
      rock.rock_obj.start();
      return rocks_arr.push(rock);
    };
    anim_loop = new Kinetic.Animation(function(frame) {
      var frameRate, time, timeDiff;

      time = frame.time;
      timeDiff = frame.timeDiff;
      frameRate = frame.frameRate;
      if (ship) {
        ship.moveShip();
        ship.rotate(frame);
        ship.fixPosition();
        ship.moveBullets();
        return ship.checkBullets();
      }
    }, game.shipLayer);
    return anim_loop.start();
  };

}).call(this);
