extract_data.R: extrai os dados de OndeFuiRoubado.com.br : ondefuiroubado_occurrences n-m TimeStamp t.csv
dt_dizcretize.R: discretiza as horas e os dias: time_discretize_nit.csv
to_logic.R: modela as clausulas l�gicas: prep.f arg.b a.n
#populate.R: popula o banco de dados: 
get_neighbourhood.R: discretiza os bairros (adiciona coluna suburb): nearby_locations_plus_neighbourhoods.csv
city_occurrences.R: pega as ocorrencias apenas de uma cidade: Niteroi_occurrences.csv
suburb.R: adiciona os bairros
nearby_location.R: pega as localidades pr�ximas das ocorrencias: nearby_location.csv
CCD.rar: pegas as posi��es pr�ximas : geo_places.csv

execu��o: extract/CCD.rar > city_occurrences > get_suburb > nearby_location > dt_dizcretize
ondefuiroubado_occurrences.csv/geo_places.csv > Niteroi_occurrences.csv > Niteroi_occurrences_suburb.R > nearby_location.csv > time_discretize_nit.csv

workflow:
