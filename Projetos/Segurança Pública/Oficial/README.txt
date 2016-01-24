extract_data.R: extrai os dados de OndeFuiRoubado.com.br : ondefuiroubado_occurrences n-m TimeStamp t.csv
time_discretize_nit.R: discretiza as horas: time_discretize_nit.csv
to_logic.R: modela as clausulas lógicas: prep.f arg.b a.n
#populate.R: popula o banco de dados: 
get_neighbourhood.R: discretiza os bairros (adiciona coluna suburb): nearby_locations_plus_neighbourhoods.csv
city_occurrences.R: pega as ocorrencias apenas de uma cidade: Niteroi_occurrences.csv
get_suburb.R: ?
nearby_location.R: pega as localidades próximas das ocorrencias: nearby_location.csv
CCD.rar: pegas as posições próximas : geo_places.csv

execução: extract_data/CCD.rar > city_occurrences > nearby_location > get_suburb > time_dizcretize
ondefuiroubado_occurrences.csv/geo_places.csv > Niteroi_occurrences.csv > nearby_location.csv