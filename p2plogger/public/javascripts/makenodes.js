var array = [];
var mycategory  = 'Men';
function addIP(i, IP){
    length = array.length;
    var k;
    for (k = length - 1; k == i - 1; k--){
        array[k + 1] = array[k]   
    }
    array[i] = IP;
}


function init(){

<% @sellerrings.length.times do |i| %>
	var predecessor = '<%= @sellerrings[i].predecessor %>';
	var IP = '<%= @sellerrings[i].ip%>';
	var successor = '<%= @sellerrings[i].successor%>';
	var category = '<%= @sellerrings[i].category%>';
	
	if (category == mycategory){
		if (predecessor == 0){
			array[0] == predecessor;
            		array[1] = IP;
            		array[2] = successor;
		}
		else{
			var found = 0;
			var j;
			for (j = 0; j < array.length; j++){
				//alert(array[j]);
				if (array[j] == predecessor){
                            	//alert('predecessor');
					found = 1;
					if (array[j +1] == successor)
                           			addIP(j+1,IP);
					else{
                            			addIP(j+1,IP);
						addIP(j+2,successor);
					}
                            		break;
                        	}               
                        	else if (array[j] == successor){
                            		//alert('sucessor');
					found = 1;
					if(array[j-1 ]== predecessor)
                            			addIP(j,IP);
                            		else if (array[j-1] == null)
						break;
					else{
						addIP(j,IP);    
                            			addIP(j-1,predecessor);
					}
					break;              
                        	}
				else if (array[j] == IP){
					//alert('IP');
					found = 1;
					if (array[j+1] != successor){
						array[j+1] = successor;
						break;
					}
					break;
				}
			}
			if (found == 0){
				//alert('not found');
                        	array[array.length] = predecessor;
                        	array[array.length] = IP;
                        	array[array.length] = successor;
                    	}
		}
	}

var mystring = '';
var k;
for (k = 0; k < array.length; k++){
	mystring +=  array[k] + '\n';
}
<% end %>

var mystring = '';
var k;
for (k = 0; k < array.length; k++){
	mystring +=  array[k] + '\n';
}
//alert(mystring);
var quarterpoint = (array.length)/4;
var interval_x = 700/array.length;
//alert(interval_x);
var interval_y = 360/array.length;
//alert(interval_y);

var data = array,
	    dataEnter = data.concat(293),
	    dataExit = data.slice(0, 2),
	    w = 720,
	    h = 360;

(function() {
var x_val;
var y_val;
var x_coordinate = [];
var y_coordinate = [];

var svg = d3.select("#chart-2").append("svg")
      .attr("width", w)
      .attr("height", h)
      .attr("left", 40);

var g = svg.selectAll(".little")
      .data(data)
      .enter().append("circle")
      .attr("class", "little")
      .attr("cx", function (d, i) {
		if (i < quarterpoint){
			x_val = (interval_x*2*quarterpoint) + i*interval_x;}
		else if ( i <= 2*quarterpoint){
			x_val = (interval_x*4*quarterpoint) - i*interval_x;}
		else if (i <= 3*quarterpoint){
			x_val = (interval_x*4*quarterpoint) - i*interval_x;}
		else{
			x_val = i*interval_x - (2*quarterpoint*interval_x);}
		x_coordinate.push(x_val);
		return x_val;
	})
      .attr("cy", function (d,i) {
		if (i < 2*quarterpoint)
			y_val = (interval_y*quarterpoint) + i*interval_y;
		else
			y_val = (interval_y*4*quarterpoint) - i*interval_y;
		y_coordinate.push(y_val);
		return y_val;		
	})
      .attr("r", 8)
      .style("fill","blue");

	
var g = svg.selectAll(".data")
	.data(data)
	.enter().append("g");
	g.append("text")
	.attr("x", function (d, i) {return x_coordinate[i] })
      	.attr("y", function (d,i) {return y_coordinate[i] - 20})
     	.attr("dy", ".35em")
      	.attr("text-anchor", "middle")
      	.text(String);
	
var link_count;
for (link_count = 0; link_count < x_coordinate.length; link_count++){
	if (link_count == (x_coordinate.length - 1)){
		g.append("svg:line")
        	.attr("stroke-width", 1)
        	.attr("stroke", "#636363")
        	.attr("x1", x_coordinate[link_count])
        	.attr("x2", x_coordinate[0])
        	.attr("y1", y_coordinate[link_count])
        	.attr("y2", y_coordinate[0]);
	}
	else{
		g.append("svg:line")
                .attr("stroke-width", 1)
                .attr("stroke", "#636363")
                .attr("x1", x_coordinate[link_count])
                .attr("x2", x_coordinate[link_count + 1])
                .attr("y1", y_coordinate[link_count])
                .attr("y2", y_coordinate[link_count + 1]);
	}
	
}

})();

}
