## Backend service

### Deployment

```
ansible-playbook -i hosts provision.yml
ansible-playbook -i hosts redeploy.yml
```

#### Request

```
GET /v1/predict-price
```


#### Response

```
{ "predicted_price": { "value": 542345, "currency": 'USD' }}
```
