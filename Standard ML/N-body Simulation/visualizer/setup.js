/* setup.js
 * file that holds much of the config information
 * also defines functionality for parsing
 */

/**** Setup for Visualizer Canvas ****/
var width = 800;   /* width of the canvas */
var height = 600;  /* height of the canvas */
var body_radius = 0.25; /* radius of each planet*/
var view_margin = body_radius + 5; /* margins for the canvas */

var sim;


var canvas = document.getElementById('simulation');
var ctx = canvas.getContext('2d');
canvas.width = width;
canvas.height = height;


/**** Functions for parsing text *****/

var text;                 /* a buffer for the transcript file text */
var points = new Array(); /* array where points will be stored */
var timeslices;           /* how many elements in the points array */
var num_planets;          /* how many elements in arrays inside points array */
var state = {
    timestep: 0,
    points: new Array(),
    radius : 0,
    colors : new Array()
};

/* sets points_array to be a multi-dimensional array of objects like */
/* {x:float y:float} returns true on success, false on failure*/
var parse = function() {
    /* reset state to null. */
    points = new Array();

    /* temp vars */
    var lines, t1, t2, t3, i, j, x, y, colorstrings;

    /* preprocess text if it's there */
    if(typeof text !== 'undefined') {
        text = text.replace(/~/g, "-");
        lines = text.trim().split('\n');
        body_radius = parseFloat(lines[0]);
        state.radius = parseFloat(lines[1]);
        state.colors = lines[2].split(",");
        num_planets = lines[3].split("),(").length;
        timeslices = lines.length-3;
    } else {
        console.log("text undefined!");
        return false;
    }

    for(j  = 3; j < lines.length; j++) {
        /* take the line and split it */
        t1 = new Array(num_planets);
        t2 = lines[j].split("),(");
        if(num_planets !== t2.length) {
            console.log("Parsing planets fail!");
            return false;
        }
        for(i = 0; i < num_planets; i++){
            t3 = t2[i].split(",");
            if(t3.length !== 2) {
                console.log("Parsing positions fail!");
                return false;
            }
            var x = parseFloat(t3[0].replace("(", ""));
            var y = parseFloat(t3[1].replace(")", ""));
            if( isNaN(x) || isNaN(y) )
            {
                console.log("Positions aren't numbers!");
                return false;
            }
            t1[i] = {x: x, y: y}
        }
        points.push(t1);
    }
    return true;
};


var parseSuccess = function(file, parseid) {
    parseid.innerHTML = file.name + ': Valid transcript';
    parseid.className = 'success';
    $("#go").show();
};

var parseFail = function(file, parseid) {
    parseid.innerHTML = file.name + ': Parse error!';
    parseid.className = 'fail';
}
