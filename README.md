## POST example (purchase)

```
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"beacon_id":"D87CEE67-C2C2-44D2-A847-B728CF8BAAAD","purchase":[{"barcode_id":4903326112852,"amount":1}, {"barcode_id":4903326112853,"amount":1}]}' "http://0.0.0.0:2999/api/v0/purchase"
```
