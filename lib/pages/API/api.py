from flask import Flask, jsonify, request
# import json
import firebase_admin 
from firebase_admin import credentials 
from firebase_admin import firestore 
from firebase_admin import initialize_app 
from firebase_admin import db 
from flask import Flask, request, jsonify
import pandas as pd 
import random 
import numpy as geek 
from sklearn.preprocessing import MinMaxScaler 
import numpy as np 
from sklearn.neighbors import NearestNeighbors
import json
app = Flask(__name__)

cred = credentials.Certificate("nozol-aadd3-firebase-adminsdk-ozhbi-a894fc47c1.json") 
firebase_admin.initialize_app(cred) 

def model (id): 

   db = firestore.client() 
   properties = list(db.collection(u'properties').stream()) 
   properties_dict = list(map(lambda x: x.to_dict(), properties)) 
   df = pd.DataFrame(properties_dict , ) 

   # drop irrelevant attributes except (property_id, city, type, price, space)
   df=df.drop(columns=['description','images','elevator', 'pool', 'User_id', 'number_of_apartment' , 'longitude','TourTime', 'property_age',
                       'number_of_room', 'in_floor','number_of_livingRooms','number_of_bathroom', 'propertyUse', 'basement', 'number_of_floors','ArrayOfbooking']) 
   df=df.drop(columns=['neighborhood','number_of_floor','latitude','Location', 'classification']) 
   # copy the data 
   df_copy = df.copy() 

   # apply normalization  
   column = 'price' 
   c2 = 'space' 
   df_copy[column] = MinMaxScaler().fit_transform(np.array(df_copy[column]).reshape(-1,1)) 
   df_copy[c2] = MinMaxScaler().fit_transform(np.array(df_copy[c2]).reshape(-1,1)) 
   # apply one hot encoding  
   encoded_data = pd.get_dummies(df_copy, columns = ['city', 'type']) 


   # the property we want to recomend to :
   property1 = encoded_data.loc[encoded_data['property_id'] == id] 

   encoded_data = encoded_data[encoded_data.property_id != id]

   #apply KNN
   nbrs = NearestNeighbors(n_neighbors=5).fit(encoded_data.drop(columns=['property_id'])) 
   distances , indices = nbrs.kneighbors(property1.drop(columns=['property_id'])) 
   distance = distances[0] 
   simelrty = []
   for x in range(5):
    defrence = (1-distance[x])*100
    simelrty.append(defrence)

   recommend_item = [] 
   index =0
   for i in indices :
     print(type(encoded_data.iloc[i]['property_id']))
     jsonObj = json.loads(encoded_data.iloc[i]['property_id'].to_json())
     print(type(jsonObj))
     for key, value in jsonObj.items(): 
      if (simelrty[index]>=80):
       print(simelrty[index])
       recommend_item.append(value)
      index+=1

   return json.dumps(recommend_item)



@app.route('/api', methods = ['GET'])
def get_recommendations():
  property_id = str(request.args['query'])
  recommend_list = model(property_id) 
  return recommend_list
  


if __name__ == "__main__":
  app.run(host="0.0.0.0")



if __name__ == "__main__":
  app.run(host="0.0.0.0")
