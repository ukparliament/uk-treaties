#!/opt/homebrew/bin/python3


import requests
import json


def send_request(pageNumberVar):
    print(pageNumberVar)

    try:
        response = requests.post(
            url="https://treaties.fcdo.gov.uk/awweb/awfp/search/1",
            headers={
                "Cookie": "JSESSIONID=E8B1412E70C13C0449A8B6E4161190B0;",
                "Content-Type": "application/json; charset=utf-8",
            },
            data=json.dumps(
                {
                    "searchDetails": {
                        "sortBy": [
                            {
                                "sequence": 0,
                                "keyType": 1,
                                "isAscending": True,
                                "fieldName": "signed_event_date",
                            }
                        ],
                        "queryStr": "*",
                        "pageNumber": 1,
                        "searchMode": {"mode": "SEARCH"},
                        "offset": pageNumberVar,
                        "pageSize": 100,
                    },
                    "searchLibraryList": ["library2_lib"],
                    "isReturnFacets": True,
                }
            ),
        )
#         print(response.content)
        with open(str(pageNumberVar) + '_batch.json', 'a') as f:
            print(response.json(), file=f)
    except requests.exceptions.RequestException:
        print("HTTP Request failed")

for x in range(10000, 15000):
    send_request(x)