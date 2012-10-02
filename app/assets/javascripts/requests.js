$(document).ready(function() { 

		
	$('#toggle_all_dst_emails').click(function() {
		$("#rest_dst_emails").fadeToggle();
	});
		
	$('#table_sents.tablesorter').tablesorter({
		headers: {
			// Do not sort on Response Text
			3: {
				sorter: false
				}
			},
			textExtraction: function(node) {
				var text;
				node_class = node.getAttribute("class");
				if ( node_class === "status") {
					text = node.childNodes[3].innerHTML;	
				}
				else if ( node_class === "time" ){
					text = parseFloat(node.innerHTML.split("s")[0].split(",").join("."));
				} else {
					text = node.innerHTML;
				}
				return text;
			}
		});			
});

