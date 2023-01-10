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

#read the data from firbase
cred = credentials.Certificate("nozol-aadd3-firebase-adminsdk-ozhbi-a894fc47c1.json") 
firebase_admin.initialize_app(cred) 





def model (id): 
  #ger all properties 
   db = firestore.client() 
   properties = list(db.collection(u'properties').stream()) 
   properties_dict = list(map(lambda x: x.to_dict(), properties)) 
   df = pd.DataFrame(properties_dict , ) 
   # drop unuesed data in recommender
   df=df.drop(columns=['description','images','elevator', 'pool', 'User_id', 'number_of_apartment' , 'longitude','TourTime', 'property_age','number_of_room', 'in_floor','number_of_livingRooms','number_of_bathroom', 'propertyUse', 'basement', 'number_of_floors','ArrayOfbooking']) 
   df=df.drop(columns=['neighborhood','number_of_floor','latitude','Location', 'classification']) 
   # copy the data 
   df_sklearn = df.copy() 
   
  # apply normalization techniques 
   column1 = 'price' 
   column2 = 'space' 
   df_sklearn[column1] = MinMaxScaler().fit_transform(np.array(df_sklearn[column1]).reshape(-1,1)) 
   df_sklearn[column2] = MinMaxScaler().fit_transform(np.array(df_sklearn[column2]).reshape(-1,1)) 
    
   #encode text data
   encoded_data = pd.get_dummies(df_sklearn, columns = ['city', 'type']) 

   encoded_data = encoded_data[encoded_data.property_id != id]
   #applay KNN 
   property1 = encoded_data.loc[encoded_data['property_id'] == id] 
   nbrs = NearestNeighbors(n_neighbors=4, algorithm='ball_tree').fit(encoded_data.drop(columns=['property_id'])) 
   distances, indices = nbrs.kneighbors(property1.drop(columns=['property_id'])) 

   distance = distances[0] 
   simelrty = []
   for x in range(3):
     defrence = (1-distance[x])*100
     simelrty.append(defrence)
   
   sum =0
   avr =0
   for s in range(3):
    sum += simelrty[s]
   avr = sum/3
   print(avr)
   ss = [] 
   for i in indices :
     print(type(encoded_data.iloc[i]['property_id']))
     jsonObj = json.loads(encoded_data.iloc[i]['property_id'].to_json())
     print(type(jsonObj))
     for key, value in jsonObj.items(): 
      ss.append(value)

   return json.dumps(ss)



@app.route('/api', methods = ['GET'])
def get_recommendations():
  property_id = str(request.args['query'])
  sim = model(property_id) 
  return sim
  





if __name__ == "__main__":
  app.run()