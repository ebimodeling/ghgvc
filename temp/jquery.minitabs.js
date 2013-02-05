//
// Minitabs 0.1
// Requires jquery
//
//
// Usage :
//
// $("#container").minitabs([speed],[slide|fade]);
//

jQuery.fn.minitabs = function(speed,effect) {
  id = "#" + this.attr('id')
  $(id + ">DIV:gt(0)").hide();
  $(id + ">UL>LI>A:first").addClass("current");
  $(id + ">UL>LI>A").click(
    function(){
      $(id + ">UL>LI>A").removeClass("current");
      $(this).addClass("current");
      $(this).blur();
      var re = /([_\-\w]+$)/i;
      var target = $('#' + re.exec(this.href)[1]);
      var old = $(id + ">DIV");
      switch (effect) {
        case 'fade':
          old.fadeOut(speed).fadeOut(speed);
          target.fadeIn(speed);
          break;
        case 'slide':
          old.slideUp(speed);  
          target.fadeOut(speed).fadeIn(speed);
          break;
        default : 
          old.hide(speed);
          target.show(speed)
      }
      return false;
    }
 );
}

