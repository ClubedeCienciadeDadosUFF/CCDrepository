library(XML)

stolen <- function(pag = 1, rows = 50, url = "http://www.ondefuiroubado.com.br/denuncias/", tolerancy = 100){
	#Basic Info
	pos <- pag;
	num_row <- 0;
	error_buff = 0;
	stolen_data <- data.frame();

	while(num_row < rows){
		
		
		#columns
		test <- tryCatch({
			
			url <- "http://www.ondefuiroubado.com.br/denuncias/";
			this_page <- htmlTreeParse(paste(url, pos), useInternalNodes = TRUE, encoding = "UTF-8");
			
			lat  		<- xpathSApply(this_page, "//*[@id='lat']", xmlValue);
			long 		<- xpathSApply(this_page, "//*[@id='lng']", xmlValue);
			date_hour	<- xpathSApply(this_page, "//*[@class='sd-info-data-hora']", xmlValue);
			city		<- xpathSApply(this_page, "//*[@class='hc-city-name']", xmlValue); 
			type		<- xpathSApply(this_page, "//h2[@class='sd-info-type']", xmlValue);
			objects		<- xpathSApply(this_page, "//*[@class='obj-label valign-middle']", xmlValue);
			error		<- xpathSApply(this_page, "//*[@class='text']", xmlValue);
			objects 	<- paste(objects, collapse = " - ");

			#Storing 
			if(identical(error, list())){
				data <- data.frame(pos, lat, long, city, date_hour, type, objects);
				stolen_data <- rbind(stolen_data,data);
				num_row = num_row + 1;
				error_buff = 0;
			}else{
				error_buff = error_buff + 1;
				if(error_buff == tolerancy){
					return (stolen_data);
				}
			}
		}, error = function (e){
			print(e);
		})
		pos = pos + 1;
	}
	return (stolen_data);
}
