// Generated by CoffeeScript 1.6.2
(function() {
  var BULLET_SPEED, HEIGHT, NUM_STARS, ROCK_RADIUS, ROCK_SPEED, SHIP_DRAG, SHIP_MAX_VEL, WIDTH, backgroundLayer, bullets_arr, check_bullet_col_asteroids, check_bullets, createRock, createRocks, end_thrust, explode_rock, fix_position, game, gameLayer, get_hypotenuse, is_bullet_outside, move_bullets, move_ship, n, remove_bullet, remove_rock, rockImageObj, rock_animations, rocks_arr, rotate_ship, set_acceleration, set_rotation, set_thrust, ship, shipImageObj, ship_acceleration, ship_animation, ship_animations, ship_rotation, ship_shoot, ship_velocity, stage, starsGroup, stars_arr, _i;

  WIDTH = 800;

  HEIGHT = 600;

  NUM_STARS = 200;

  SHIP_MAX_VEL = 4;

  SHIP_DRAG = 0.01;

  BULLET_SPEED = 5;

  ROCK_SPEED = 2;

  ROCK_RADIUS = 40;

  ship = null;

  game = null;

  stars_arr = [];

  rocks_arr = [];

  bullets_arr = [];

  ship_acceleration = 0;

  ship_rotation = 0;

  ship_velocity = {
    x: 0,
    y: 0
  };

  createRocks = false;

  ship_animations = {
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

  rock_animations = {
    idle: [
      {
        x: 0,
        y: 0,
        width: 90,
        height: 90
      }
    ]
  };

  stage = new Kinetic.Stage({
    container: "container",
    width: WIDTH,
    height: HEIGHT
  });

  backgroundLayer = new Kinetic.Layer;

  gameLayer = new Kinetic.Layer;

  backgroundLayer.add(new Kinetic.Rect({
    x: 0,
    y: 0,
    width: WIDTH,
    height: HEIGHT,
    fill: "#000000"
  }));

  starsGroup = new Kinetic.Group;

  for (n = _i = 0; 0 <= NUM_STARS ? _i <= NUM_STARS : _i >= NUM_STARS; n = 0 <= NUM_STARS ? ++_i : --_i) {
    starsGroup.add(new Kinetic.Star({
      x: Math.random() * WIDTH,
      y: Math.random() * HEIGHT,
      numPoints: 5,
      innerRadius: Math.random() + 0.5,
      outerRadius: Math.random() * 2 + 1.5,
      fill: "#FFFFAA"
    }));
  }

  backgroundLayer.add(starsGroup);

  shipImageObj = new Image();

  shipImageObj.src = "images/double_ship.png";

  shipImageObj.onload = function() {
    ship = new Kinetic.Sprite({
      x: WIDTH / 2 - 40,
      y: HEIGHT / 2 - 32,
      image: shipImageObj,
      animation: "idle",
      animations: ship_animations,
      frameRate: 1,
      width: 80,
      height: 65
    });
    ship.setOffset(40, 32);
    gameLayer.add(ship);
    return ship.start();
  };

  rockImageObj = new Image();

  rockImageObj.src = "images/asteroid_blue.png";

  rockImageObj.onload = function() {
    createRocks = true;
    return createRock();
  };

  createRock = function() {
    var rock;

    if (createRocks) {
      rock = new Kinetic.Sprite({
        x: 100,
        y: 100,
        image: rockImageObj,
        animation: "idle",
        animations: rock_animations,
        frameRate: 1,
        width: 90,
        height: 90
      });
      rock.setOffset(45, 45);
      gameLayer.add(rock);
      rock.start();
      return rocks_arr.push(rock);
    }
  };

  set_thrust = function() {
    return ship.setAnimation('thrust');
  };

  end_thrust = function() {
    return ship.setAnimation('idle');
  };

  set_acceleration = function(val) {
    ship_acceleration += val;
    return set_thrust();
  };

  set_rotation = function(val) {
    return ship_rotation = val;
  };

  get_hypotenuse = function(x, y) {
    return Math.sqrt(x * x + y * y);
  };

  rotate_ship = function(frame) {
    var angle_diff, angular_speed;

    angular_speed = Math.PI / 2;
    angle_diff = frame.timeDiff * angular_speed / 1000;
    return ship.rotate(ship_rotation * angle_diff);
  };

  move_ship = function() {
    var movement_angle, speed, speed_angle;

    if (ship_acceleration !== 0) {
      movement_angle = ship.getRotation();
      ship_velocity.x += Math.cos(movement_angle) * ship_acceleration;
      ship_velocity.y += Math.sin(movement_angle) * ship_acceleration;
      ship_acceleration = 0;
    }
    speed = get_hypotenuse(ship_velocity.x, ship_velocity.y);
    if (speed > SHIP_MAX_VEL) {
      speed = SHIP_MAX_VEL;
    } else if (speed > 0) {
      speed -= SHIP_DRAG;
    }
    speed_angle = Math.atan2(ship_velocity.y, ship_velocity.x);
    ship_velocity.x = Math.cos(speed_angle) * speed;
    ship_velocity.y = Math.sin(speed_angle) * speed;
    return ship.move(ship_velocity.x, ship_velocity.y);
  };

  fix_position = function() {
    if (ship.getX() <= 0) {
      ship.setX(WIDTH);
    } else if (ship.getX() >= WIDTH) {
      ship.setX(0);
    }
    if (ship.getY() <= 0) {
      return ship.setY(HEIGHT);
    } else if (ship.getY() >= HEIGHT) {
      return ship.setY(0);
    }
  };

  ship_shoot = function() {
    var bullet;

    bullet = new Kinetic.Rect({
      x: ship.getX(),
      y: ship.getY(),
      width: 8,
      height: 4,
      fill: '#00FFFF'
    });
    bullet.setRotation(ship.getRotation());
    bullet.move(Math.cos(ship.getRotation()) * 40, Math.sin(ship.getRotation()) * 40);
    gameLayer.add(bullet);
    return bullets_arr.push(bullet);
  };

  move_bullets = function() {
    return _.each(bullets_arr, function(bullet) {
      return bullet.move(Math.cos(bullet.getRotation()) * BULLET_SPEED, Math.sin(bullet.getRotation()) * BULLET_SPEED);
    });
  };

  check_bullets = function() {
    return _.each(bullets_arr, function(bullet) {
      if (is_bullet_outside(bullet)) {
        bullets_arr.splice(bullets_arr.indexOf(bullet), 1);
        return bullet.destroy();
      }
    });
  };

  is_bullet_outside = function(bullet) {
    if (bullet.getX() < 0 || bullet.getX() > WIDTH) {
      return true;
    }
    if (bullet.getY() < 0 || bullet.getY() > HEIGHT) {
      return true;
    }
    return false;
  };

  ship_animation = new Kinetic.Animation(function(frame) {
    if (ship) {
      move_ship();
      rotate_ship(frame);
      fix_position();
      move_bullets();
      check_bullets();
      return _.each(bullets_arr, function(bullet) {
        return check_bullet_col_asteroids(bullet);
      });
    }
  });

  check_bullet_col_asteroids = function(bullet) {
    return _.each(rocks_arr, function(rock) {
      var distance;

      distance = get_hypotenuse(bullet.getX() - rock.getX(), bullet.getY() - rock.getY());
      if (distance <= ROCK_RADIUS) {
        return explode_rock(rock, bullet);
      }
    });
  };

  remove_bullet = function(bullet) {
    var index;

    if (bullet) {
      index = bullets_arr.indexOf(bullet);
      bullet.destroy();
      return bullets_arr.splice(index, 1);
    }
  };

  remove_rock = function(rock) {
    var index;

    if (rock) {
      index = rocks_arr.indexOf(rock);
      rock.destroy();
      return rocks_arr.splice(index, 1);
    }
  };

  explode_rock = function(rock, bullet) {
    remove_bullet(bullet);
    return remove_rock(rock);
  };

  ship_animation.start();

  stage.add(backgroundLayer);

  stage.add(gameLayer);

  document.onkeydown = function(event) {
    switch (event.keyCode) {
      case 37:
      case 65:
        set_rotation(-1);
        break;
      case 38:
      case 87:
        set_acceleration(.2);
        break;
      case 39:
      case 68:
        set_rotation(1);
        break;
      case 40:
      case 83:
        console.log("down");
        break;
      case 32:
        ship_shoot();
        break;
      default:
        end_thrust();
    }
    return event.preventDefault();
  };

  document.onkeyup = function(event) {
    switch (event.keyCode) {
      case 38:
      case 87:
        return end_thrust();
      case 37:
      case 65:
        return set_rotation(0);
      case 39:
      case 68:
        return set_rotation(0);
    }
  };

}).call(this);
