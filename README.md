# CHURN
I took a random consumer dataset from kaggle and tried to find key insights on what contributes to Churn and how can it be reduced?
As the dataset is large (22mb) It will not let me upload it here but you can find it on kaggle(https://www.kaggle.com/code/mostafahabibi1994/customer-churn-eda-part-1)

# Methodology
Firstly i uploaded the dataset to python and cleaned the dataset. Then, I uploaded the clean dataset into PostGreSql and analyzed the churn by different characteristics and queries that you can find attached.( A lot more detailed queries in there and the logic that i applied)

The key things I found:
The most important thing to improve would be the support calls. Firstly, we would need to understand why are people calling for support is it the fact that the service is breaking down or the fact that it is too complicated to use. After we know this information we could move further. We could also appoint independent "fake" callers, so we would know that our  customer support is up to a companies expectations. Another thing we could do is dig deeper for payment delays. Is our pricing strategy correct or whether we need to improve payment methods and so on. Lastly, we need to imprement targeted retention for female customers
and find out the exact reasons on why their retention_rate is so small compared to males.

# Not fully finished project 
To improve the project further I am planning to do some predictive analysis, consumer segmentation analysis(clustering, K means or hierarchical clustering), Customer Lifetime Value Prediction as well as connecting it to tableau for some data vizes.
