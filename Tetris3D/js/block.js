// Generated by CoffeeScript 1.6.2
(function() {
  window.Tetris = {};

  Tetris.Block = (function() {
    function Block(size) {
      this.size = size;
      this.moving = false;
      this.static_colors = [0x0000FF, 0x3333FF, 0x6565FF, 0x9999FF, 0xB2B2FF, 0xCBCBFF, 0xE5E5FF, 0xE5FFE5, 0xCBFFCB, 0xB2FFB2, 0x99FF99, 0x65FF65, 0x33FF33, 0x00FF00];
      this.moving_color = [0xFFFFFF];
      this.cube = new THREE.SceneUtils.createMultiMaterialObject(new THREE.CubeGeometry(this.size, this.size, this.size), [
        new THREE.MeshBasicMaterial({
          color: 0xFFFFFF,
          wireframe: true,
          transparent: true
        }), new THREE.MeshBasicMaterial({
          color: 0xFF0000,
          transparent: true,
          opacity: 0.5
        })
      ]);
      console.log(this.cube);
    }

    Block.prototype.setColor = function(color) {
      return this.color = color;
    };

    Block.prototype.print = function() {
      return console.log(this.cube.position.x + ", " + this.cube.position.y + ", " + this.cube.position.z);
    };

    Block.prototype.erase = function() {
      this.active = false;
      return scene.remove(this.cube);
    };

    return Block;

  })();

}).call(this);
