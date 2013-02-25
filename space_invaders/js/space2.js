// Generated by CoffeeScript 1.4.0
(function() {
  var BLOCK_SIZE, HEIGHT, HEIGHT_NUM_BLOCKS, WIDTH, WIDTH_NUM_BLOCKS, alienDownMove, alienMovPause, alienSideMove, aliensArr, aliensGroup, aliensLayer, animations, background, backgroundLayer, bulletSpeed, bulletsArr, canon, canonAnimation, canonLayer, canonSpeed, imageObj, stage;

  BLOCK_SIZE = 3;

  WIDTH_NUM_BLOCKS = 184;

  HEIGHT_NUM_BLOCKS = 191;

  WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE;

  HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE;

  aliensArr = [];

  bulletsArr = [];

  canon = null;

  alienSideMove = 2 * BLOCK_SIZE;

  alienDownMove = 6 * BLOCK_SIZE;

  alienMovPause = 1;

  canonSpeed = 15;

  bulletSpeed = 20;

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

  imageObj = new Image();

  imageObj.onload = function() {
    canon = new Kinetic.Sprite({
      x: WIDTH / 2 - 7 * BLOCK_SIZE,
      y: HEIGHT - 8 * BLOCK_SIZE,
      image: imageObj,
      animation: 'canon',
      animations: animations,
      frameRate: 1
    });
    canonLayer.add(canon);
    stage.add(canonLayer);
    return canon.start();
  };

  imageObj.src = "img/aliens_all.png";

  canonAnimation = new Kinetic.Animation(function(frame) {
    if (canon) {
      return document.onkeydown = function(event) {
        switch (event.keyCode) {
          case 37:
          case 65:
            return canon.move(-canonSpeed, 0);
          case 39:
          case 68:
            return canon.move(canonSpeed, 0);
          case 32:
            return console.log("pew");
        }
      };
    }
  });

  canonAnimation.start();

}).call(this);