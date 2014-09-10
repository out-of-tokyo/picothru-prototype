## POST example (purchase)

```
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"store_id":1,"purchase":[{"barcode_id":4903326112852,"amount":1}, {"barcode_id":4903326112853,"amount":1}]}' "http://0.0.0.0:2999/api/v0/purchase"
```