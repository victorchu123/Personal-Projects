/* visualizer.js
 * functionality for the visualizer simulation
 */

var clear = function(){
    ctx.fillStyle = '#101010';
    //set active color to #d0e... (nice blue)
    ctx.beginPath();    //start drawing
    ctx.rect(0, 0, width, height);    // covering whole canvas
    ctx.closePath();    //end drawing
    ctx.fill();    //fill rectangle with selected color
}

/* scaling function taken straight from old visualizer view.sml:112
 * view_margin is the body_width + 5 (also from view.sml) */
var createTransform = function () {
    var minx = -state.radius;
    var miny = -state.radius;
    var maxx = state.radius;
    var maxy = state.radius;

    var rangex = maxx-minx;
    var rangey = maxy-miny;
    var scale = Math.min (
        ((width - 2*view_margin) / rangex),
        ((height - 2*view_margin) / rangey)
    );

    var centerx = (rangex/2) + minx;
    var centery = (rangey/2) + miny;

    var ret = function(x,y) {
        var tx = width/2 + Math.floor((x-centerx)*scale);
        var ty = height/2 + Math.floor((y-centery)*scale);
        return {x:tx, y:ty};
    };

    return ret;
};

var drawBody = function(color, pt) {
    // the point is (0,0) centered, but our canvas is not
    // in addition, the coordinates are scaled fucking huge
    var scalePoints = state.scaleFn;
    var scale = Math.max(state.radius, state.radius);
    var pos = scalePoints(pt.x, pt.y);

    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(pos.x, pos.y, body_radius, 0, Math.PI*2, true);
    ctx.closePath();
    ctx.lineWidth = 1;
    ctx.strokeStyle = color;
    ctx.stroke();
    // console.log("Draw at x: " + pos.x + " y: " + pos.y);
}

var fillBody = async.apply(drawBody, '#FFFFFF');
var eraseBody = async.apply(drawBody, '#000000');

var simLoop = function(){
    clear();

    var step = function (st) {
       /* async.map(st.points, eraseBody);*/
        st.timestep += 1;
        st.points = points[st.timestep];
        for (i = 0 ; i < num_planets ; i = i + 1) {
            drawBody(st.colors[i], st.points[i]);
        }
    }
    step(state);

    if (state.timestep < timeslices-1) {
        sim = setTimeout(simLoop, 1000 / 50);
    } else {
        document.getElementById('parseOut').innerHTML = "End Simulation.";
        document.getElementById('parseOut').className = 'end';
    }
}

var startSim = function() {
    state.timestep = 0;
    state.points = points[0];
    state.scaleFn = createTransform();
    simLoop();
}

clear();
$("#go").hide();
$("#go").click(startSim);
