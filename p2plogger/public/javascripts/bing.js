function chartname(specifier){
	var chart_string = "chart_" + specifier;
	return chart_string;
}

function draw(array, chart_id, buyer_array){
	var mystring = '';
	var k;
	for (k = 0; k < array.length; k++){
		mystring +=  array[k] + '\n';
	}
	//alert(mystring);
	var quarterpoint = (array.length)/4;
	var interval_x = 400/array.length;
	//alert(interval_x);
	var interval_y = 300/array.length;
	//alert(interval_y);

	var data = array,
	dataEnter = data.concat(293),
	dataExit = data.slice(0, 2),
	w = 720,
	h = 360;

	var x_val;
	var y_val;
	var x_coordinate = [];
	var y_coordinate = [];
	var svg = d3.select(chart_id).append("svg")
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
		var perseller_buyer_array = [];
		if (buyer_array.length != 0){
			var blink_count;
			for (blink_count = 0; blink_count < buyer_array.length; blink_count++){
				var this_length = buyer_array[blink_count].search(":");
				var this_ip = buyer_array[blink_count].slice(this_length + 1, buyer_array[blink_count].length)
				if (array[link_count] == buyer_array[blink_count].slice(0, this_length)){
					perseller_buyer_array.push(this_ip); 	
				}		
			}		
		if (perseller_buyer_array.length != 0){
			var slope = (y_coordinate[link_count] - 150)/(x_coordinate[link_count] - 200);
			var theta = Math.atan(slope);
			//var distance = Math.sqrt(Math.pow((y_coordinate[link_count] - 150),2) + Math.pow((x_coordinate[link_count] - 200),2));
			var theta_interval = (1.2/perseller_buyer_array.length);
			var each_ip;			
			for (each_ip = 0; each_ip < perseller_buyer_array.length; each_ip++){
				var radial_x = x_coordinate[link_count] + 60*Math.cos(theta + each_ip*theta_interval);
				var radial_y = y_coordinate[link_count] + 60*Math.sin(theta + each_ip*theta_interval);	
				g.append("svg:circle")
				.attr("cx", radial_x)
				.attr("cy", radial_y)
				.attr("r", 4)
		      		.style("fill","red");
				g.append("svg:line")
				.attr("stroke-width", 0.25)
				.attr("stroke", "green")
				.attr("x1", x_coordinate[link_count])
				.attr("x2", radial_x)
				.attr("y1", y_coordinate[link_count])
				.attr("y2", radial_y);
				g.append("svg:text")
				.attr("x", radial_x + 10)
			      	.attr("y", radial_y - 10)
			     	.attr("dy", ".35em")
			      	.attr("text-anchor", "middle")
			      	.text(perseller_buyer_array[each_ip]);
			}
		}		
		}
	}
}

function remove(){
	try{
		d3.select(chart_id).select("svg").remove();
		d3.select(chart_id).select("g").remove();
	}
	catch(err){}
}
