import sys
import cdsapi

YEAR = sys.argv[1]
MON  = sys.argv[2]

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-pressure-levels',
    {
        'product_type': 'reanalysis',
        'format': 'grib',
        'variable': [
            'geopotential',
            'temperature',
            'u_component_of_wind',
            'v_component_of_wind',
            'relative_humidity',
            'specific_humidity',
            ],
        'pressure_level': [
            '1','2','3',
            '5','7','10',
            '20','30','50',
            '70','100','125',
            '150','175','200',
            '225','250','300',
            '350','400','450',
            '500','550','600',
            '650','700','750',
            '775','800','825',
            '850','875','900',
            '925','950','975',
            '1000'
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
    'era5/'+YEAR+'.'+MON+'.prs.grib')
