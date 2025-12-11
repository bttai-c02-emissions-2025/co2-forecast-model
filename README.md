# Modeling Global CO2 Emissions for a Net-Zero Future

### 👥 **Team Members**
Carly Cohen  
Caitlyn Wei  
Isabella Wong  
Tygan Chin  
Katie Meier  
Tessa Volpe  

Individul Tasks: Each team member forecasted emissions for one country. We cleaned the data, interpolated missing values, added exogenous variables such as population, decomposed our data, modeled it with a cubic or quadratic model, and forecasted emissions until 2050. 

Group Tasks: Data exploration, data analysis, data visualization, model selection, time series forecasting, overall project coordination   
| Name             | GitHub Handle | Contribution                                                              |
|------------------|---------------|--------------------------------------------------------------------------   |
| Carly Cohen    | @carlyycohen | All group tasks        				     |
| Katie    | @katiemeier | All group tasks        				                                         
| Isabella    | @ | All group tasks        				                                         |
| Tygan   | @ | All group tasks        				                                         |
| Caitlyn    | @ | All group tasks        				                                         |
| Tessa   | @ | All group tasks        				                                         |
---

## 🎯 **Project Highlights**

- Developed a machine learning model using ARIMA and SARIMA time series forecasting to address different country’s concerns of meeting carbon neutral goals by 2050.
- Achieved RMSE scores of 32-36 with our highest performing models, meaning that our models predictions were only off by about 32-36 metric tons of CO2 emissions from the actual values. Forecasting with these models demonstrated a continuous decrease in carbon emissions leading into 2050.  
- Generated actionable insights to inform business decisions at MathWorks
- Implemented time series forecasting to address industry expectations for various countries..

---

## 👩🏽‍💻 **Setup and Installation**

* Install [MATLAB](url)
* Clone the repository into a local directory. In MATLAB, open the directory that you cloned the repository into
* Access the [dataset](url) from the Global Carbon Project - Download GCB2024v18_MtCO2_flat.csv and GCB2024v18_population_flat.csv
* How to run the notebook or scripts  
To run the code for france:
Take emissions data formatted in the same way as the global carbon project dataset and download it into a CSV titled “CO2
Run CO2_datacleaningscript to clean the data
Run quadratic modeling script
Run France_Forecast_To_2050.mlx

---

## 🏗️ **Project Overview**

The Break Through Tech AI Program paired our group with a mentor on the Computational Finance Team at MathWorks, our host company. The project objective was aligned with the computational finance team’s goal to understand how climate change could impact financial systems and global economies. Our objective was to model what different countries' CO2 emissions will look like in 2050 to be able to give recommendations for how to change their carbon footprint tactics. These forecasts can help inform global climate strategies and support data driven pathways towards a sustainable future. 


---

## 📊 **Data Exploration**

We used the Global Carbon Project dataset for Carbon Emissions, which contains annual carbon emissions for 222 countries from 1750 to 2023. The Global Carbon Project is open source, and provides standardized emissions reporting.

These emissions are broken down by major sectors like coal, oil, gas, and others, but we focused on the total global emissions for our models. We selected our 6 countries based on their status as major global emitters, availability of complete data, geographic diversity, and relevance to key stakeholders. The countries we selected were: France, the United States, the United Kingdom, Brazil, China, and India. We foccused on total CO₂ emissions for the clearest picture of each country’s contribution.

After we isolated the countries we would be dealing with, we began cleaning the data. Observations began in 1750, but most of the countries did not begin recording emission data until much later (for example Brazil started in 1856), so we removed all unnecessary empty rows. We then interpolated inclusive missing values via linear interpolation in the MATLAB Data Cleaner Application and updated the "Total" column (which we will be primarily working with) to include the newly interpolated measurements. Finally, we increased the stationarity of our data via data transformations, such as log or differencing, because time-series forecasting models assume inputted data is stationarity. After this last step, our data was ready for the modeling process.

Here is an example of our data before and after making it stationary.   
Before:    
<img width="577" height="342" alt="Screenshot 2025-10-20 195055" src="https://github.com/user-attachments/assets/d02eb56f-83a0-4ef4-831e-f36ac1d116f6" />

After:  
<img width="577" height="342" alt="Screenshot 2025-10-20 195116" src="https://github.com/user-attachments/assets/ff6d0267-45ca-4879-99bf-12ac56527d64" />


## 🧠 **Model Development**

* We tried building models using Linear (S)ARIMA(X) modeling, Piecewise Linear (S)ARIMA(X) models, and finally Cubic and Quartic (S)ARIMA(X) models. We discovered that Linear Models were at the risk of overfitting and they were unable to capture the reductions in our dataset most likely due to their inability to predict structural changes. Similarly, Piecewise Linear models were unable to follow the unpredictable changes of our dataset due to the predictions being broken into pieces. Finally we decided to model our data with Cubic and Quartic models, due to their ability to capture the curves in our data without overfitting
* We used grid search, testing values of [0, 5] for the moving average and autoregressive parameters. 
* We initially used 20 years of our data for the testing data, but as a result, our training data did not include reduced emissions that happened as a result of the Kyoto Protocol and Paris Agreements, so our results were predicting exponetial emissions growth. To resolve this, we limited our testing year to 5 years (2018-2023), which produced much better results.
* We used AIC and BIC to determine how well our (S)ARIMA(X) models could fit the remainder of our data, and we used RMSE to measure the difference between our model's predicted emissions values and the actual values.

---

## 📈 **Results & Key Findings**

Our highest performing models achieved RMSE scores of 32-36, meaning that our models' predictions were only off by about 32-36 metric tons of CO2 emissions from the actual values. AIC and BIC values averaged to be -400, where values with a higher magnitude indicate a better fit. Our insights from these models are that France and the UK are trending downward in their emissions, looking like they may reach carbon neutrality by 2050. 

Results from France:  
  
<img width="577" height="342" alt="Screenshot 2025-12-11 141846" src="https://github.com/user-attachments/assets/4992ceda-570d-4aad-a97c-4805d304c5cc" />    

Results from the United Kingdom:  
  
<img width="577" height="342" alt="Screenshot 2025-12-11 141903" src="https://github.com/user-attachments/assets/3df52433-b934-4783-acc0-07e078593b4b" />

---

## 🚀 **Next Steps**


* What are some of the limitations of your model?
* What would you do differently with more time/resources?
* What additional datasets or techniques would you explore?

One limitation of the final models we chose, quadratic or cubic, is that they may not adequately capture the trend for every country’s data trends. If we had more time and resources, we would try new models and potentially try combining variations of the models we worked with to see what produced the best results. Additionally, we would incorporate more exogenous variables such as GDP, and then investigate the differences in the different types of energy emissions as opposed to just the total. We would also love to compare our projected emissions with each country’s goals to be able to better understand how on track they are. 

---

## 📝 **License**

Our project can be used by anyone with a MATLAB 2025b license. 

---

## 📄 **References** 
[MathWorks: Data-Driven Forecasting for Sustainability](url)  
[Data Analysis in MATLAB Course](url)



---

## 🙏 **Acknowledgements** 

We would like to thank our incredible challenge advisor, Alejandra Peña-Ordieres, and our TA, Kailey Bridgeman, for their support and guidance throughout this project. We would also like to thank Maxime and Chu! We could not have done this project without their continuous support through the BTTAI program. 

