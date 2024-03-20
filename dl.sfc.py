
import sys
import cdsapi

YEAR = sys.argv[1]
MON  = sys.argv[2]


c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'format': 'grib',
        'variable': [
            '10m_u_component_of_wind', '10m_v_component_of_wind', '2m_dewpoint_temperature',
            '2m_temperature', 'land_sea_mask', 'mean_sea_level_pressure',
            'sea_ice_cover', 'sea_surface_temperature',
            'skin_temperature', 'snow_density', 'snow_depth',
            'soil_temperature_level_1', 'soil_temperature_level_2', 'soil_temperature_level_3',
            'soil_temperature_level_4', 'surface_pressure', 'geopotential',
            'volumetric_soil_water_layer_1', 'volumetric_soil_water_layer_2', 'volumetric_soil_water_layer_3',
            'volumetric_soil_water_layer_4',
            ],
        'year': YEAR,
        'month': MON,
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31',
          ],
        'time': ['00:00', '03:00', '06:00', '09:00',
            '12:00', '15:00', '18:00', '21:00',],

        'area': [
            40, 60, 0, 110,
            ],
        },
    'era5/'+YEAR+'.'+MON+'.sfc.grib')
