// Generated by CoffeeScript 1.6.2
(function() {
  var BULLET_SPEED, HEIGHT, NUM_STARS, ROCK_RADIUS, ROCK_SPEED, SHIP_DRAG, SHIP_MAX_VEL, WIDTH, animate_rocks, backgroundLayer, bullets_arr, check_bullet_col_asteroids, check_bullets, check_ship_col_rock, createExplosion, createRock, createRocks, end_thrust, explode_rock, explode_rock_ship, explosion, explosionImageObj, explosion_animations, fix_position, fix_rocks_position, gameLayer, game_over, generate_rocks, get_hypotenuse, is_bullet_outside, move_bullets, move_ship, n, points, remove_bullet, remove_rock, rockImageObj, rock_animations, rocks_arr, rocks_dir, rocks_interval, rocks_start, rotate_ship, set_acceleration, set_rotation, set_thrust, ship, shipImageObj, ship_acceleration, ship_animation, ship_animations, ship_rotation, ship_shoot, ship_velocity, stage, starsGroup, stars_arr, _i;

  WIDTH = window.innerWidth;

  HEIGHT = window.innerHeight;

  NUM_STARS = 200;

  SHIP_MAX_VEL = 4;

  SHIP_DRAG = 0.01;

  BULLET_SPEED = 5;

  ROCK_SPEED = 1;

  ROCK_RADIUS = 40;

  ship = null;

  explosion = null;

  stars_arr = [];

  bullets_arr = [];

  rocks_arr = [];

  rocks_dir = [];

  ship_acceleration = 0;

  ship_rotation = 0;

  ship_velocity = {
    x: 0,
    y: 0
  };

  rocks_interval = 2000;

  rocks_start = 0;

  points = 0;

  createRocks = false;

  createExplosion = false;

  game_over = false;

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

  explosion_animations = {
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
        x: 0,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 128,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 256,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 384,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 512,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 640,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 768,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 896,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1024,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1152,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1280,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1408,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1536,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1664,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1792,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 1920,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2048,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2176,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2304,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2432,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2560,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2688,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2816,
        y: 0,
        width: 128,
        height: 128
      }, {
        x: 2944,
        y: 0,
        width: 128,
        height: 128
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
    return createRock(100, 100);
  };

  explosionImageObj = new Image();

  explosionImageObj.src = "images/explosion_alpha.png";

  explosionImageObj.onload = function() {
    console.log(explosionImageObj);
    createExplosion = true;
    explosion = new Kinetic.Sprite({
      x: 0,
      y: 0,
      imageObj: explosionImageObj,
      animation: 'idle',
      animations: explosion_animations,
      frameRate: 5,
      width: 128,
      height: 128
    });
    explosion.setOffset(64, 64);
    gameLayer.add(explosion);
    return explosion.start();
  };

  createRock = function(x, y) {
    var angle, rock, speed, velocity;

    if (createRocks) {
      rock = new Kinetic.Sprite({
        x: x,
        y: y,
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
      rocks_arr.push(rock);
      angle = Math.random() * Math.PI * 2;
      velocity = Math.random() * 1 + ROCK_SPEED;
      speed = {
        x: Math.cos(angle) * velocity,
        y: Math.sin(angle) * velocity
      };
      return rocks_dir.push(speed);
    }
  };

  animate_rocks = function(frame) {
    return _.each(rocks_arr, function(rock) {
      var angle_diff, angular_speed, index;

      angular_speed = Math.PI / 2;
      angle_diff = frame.timeDiff * angular_speed / 2000;
      rock.rotate(angle_diff);
      index = rocks_arr.indexOf(rock);
      return rock.move(rocks_dir[index].x, rocks_dir[index].y);
    });
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

  fix_rocks_position = function() {
    return _.each(rocks_arr, function(rock) {
      if (rock.getX() <= 0) {
        rock.setX(WIDTH);
      } else if (rock.getX() >= WIDTH) {
        rock.setX(0);
      }
      if (rock.getY() <= 0) {
        return rock.setY(HEIGHT);
      } else if (rock.getY() >= HEIGHT) {
        return rock.setY(0);
      }
    });
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
    if (ship && !game_over) {
      move_ship();
      rotate_ship(frame);
      fix_position();
      move_bullets();
      check_bullets();
      _.each(bullets_arr, function(bullet) {
        return check_bullet_col_asteroids(bullet);
      });
      check_ship_col_rock();
      animate_rocks(frame);
      fix_rocks_position();
      return generate_rocks(frame);
    }
  });

  check_bullet_col_asteroids = function(bullet) {
    return _.each(rocks_arr, function(rock) {
      var distance;

      distance = get_hypotenuse(bullet.getX() - rock.getX(), bullet.getY() - rock.getY());
      if (distance <= ROCK_RADIUS) {
        explode_rock(rock, bullet);
        points += 10;
        return $("#score").html("Score: " + points);
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
      rocks_arr.splice(index, 1);
      return rocks_dir.splice(index, 1);
    }
  };

  explode_rock = function(rock, bullet) {
    explosion.setPosition(rock.getX(), rock.getY());
    explosion.setAnimation("explosion");
    remove_bullet(bullet);
    return remove_rock(rock);
  };

  explode_rock_ship = function(rock) {
    remove_rock(rock);
    ship.destroy();
    game_over = true;
    return $("#game_over").html("GAME OVER");
  };

  check_ship_col_rock = function() {
    if (ship) {
      return _.each(rocks_arr, function(rock) {
        var distance;

        distance = get_hypotenuse(rock.getX() - ship.getX(), rock.getY() - ship.getY());
        if (distance <= ROCK_RADIUS + 30) {
          return explode_rock_ship(rock);
        }
      });
    }
  };

  generate_rocks = function(frame) {
    var randomX, randomY;

    if (rocks_start === 0 || frame.time - rocks_start > rocks_interval) {
      rocks_start = frame.time;
      randomX = Math.random() * WIDTH;
      randomY = Math.random();
      if (randomY < 0.5) {
        randomY = 0;
      } else {
        randomY = HEIGHT;
      }
      return createRock(randomX, randomY);
    }
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
