#!/opt/homebrew/bin/python3


import requests
import json

# remember to pick up a new session id cookie
def send_request(pageNumberVar):
    print(pageNumberVar)

    try:
        response = requests.post(
            url="https://treaties.fcdo.gov.uk/awweb/awfp/search/1",
            headers={
                "Cookie": "JSESSIONID=8E4B95FEC610437C9438077D1D8AC25B;",
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
        with open(str(pageNumberVar) + '_batch.json', 'w') as f:
            print(response.text, file=f)
    except requests.exceptions.RequestException:
        print("HTTP Request failed")

# 21437 is the last seen in March 2022
# for x in range(21000, 21437):
for x in range(21437, 21491):
    send_request(x)