# Overview
- Analyzing indicators affecting 
# 
Python - Data Cleaning :
- This dataset isn’t just messy — its structure is compromised.
- The misalignment likely stems from commas (',') inside the name column during import. These commas are misinterpreted as delimiters, causing data to shift into the wrong columns.

SQL - Brief descriptions :
1.  Which Category has the highest success percentage? How many projects have been successful?
![image](https://github.com/user-attachments/assets/b3de002d-eaac-486c-9c44-79f935acf337)
- `Dance` had the highest success rate at **65.85%** (2.104 successfull out of 3.377 projects). Despite its small scale, it's a **highly effective category for fundraising**
- `Theater` ranked second with a success rate at **64.2%** - total projects launched was higher than Dance (9.340 projects)
- `Comics` remained a consistent fundraising performance (**56.7%**) - 1 in every 2 projects succeeds.
 - `Music` and `Film & Video` had the highest number of projects: 41.106 & 51.128, respectively, but lower success rates, particularly `Film & Video` accounted for **41.9%**. The reason stemmed from too many projects had been launched in the past. The later projects lacked of break-through, they could not attract the fund from the investors or supports in the community.
- `Art` ranked third in number of projects (21.803), fell into bottom 3 in success rate **44.38%**
- 💡More projects do not mean that that category has higher success rates

2. How does the "goal" amount affect the likelihood of success?

a) Are small goals under 1,000 more likely to succeed ?

![image](https://github.com/user-attachments/assets/76e42d0c-e226-413f-8011-e89320dd8393)

- Small projects fundraised small goals accounts for **52.82%** - 25783 successfull projects
- 💡A 5% gap between success rate and failure showing that the market is highly competitive. A "50-50" chance is risky for new project fundraisers
- Show clearly unique values to investors if choose large-community categories.
- Consider categories such as `Dance` or `Threater` which have fewer projects but higher success rates.

b) Which goal range has the highest success rate?

![image](https://github.com/user-attachments/assets/c6154a2e-eed5-4f9c-8c85-4a1b21c48d4a)

- **Small Goal Range** had the highest success rate at **52.82%** with 25,783 successful projects
- **Medium Goal Range** followed with a **46.5%** success rate, while its total and success projects had double values compared to Small group
- **Large Goal Range** had the highest number of  launched projects, but only rank third in success rate **34.1%**
- **Enterprise-Level Goal Range** only had **13%** success rates, suggesting that high goals are rarely met.
- 💡Small & Medium goal ranges shows the balance  between success rate and scale, which make them ideal and safety for **new people** or **Startups** to reach their funding targets and build a presence in the community.
- 💡Medium & Large goal ranges are suitable for brands that have their own community to increase their project scale, but still have the high success rate for raising investment.
- 💡Small Goal is the safe and effective starting point for newcomers in **KickStarter**

3. What is the success rate of fundraising based on the pledged amount and the original goal ? (Pledged / Goal)
![image](https://github.com/user-attachments/assets/1f324c9c-074f-4811-b774-46a94ace69bf)
- `Games` ranked one  with the average funding rate **918.72%**. This highlights the strong community and supports.
- `Comics` and `Comics` with average rates **787%** - **645%**, respectively. Additionally, these two categories not only raise significantly more in their targets, but also appear in top for successful projects.
- `Journalism` & `Photography` seems like difficult to meet their funding goals (less than 70% both categories)
- `Dance` had top 1 success rate, however had a lower pledged amount than expected **85%**
- 💡Overall, the data suggest that the **Kickstarter backers** tend to  favor **Entertainment, Creative and Art** projects(Games, Comics, Music). They show less support for categories like `Journalism` | `Photography`

4. Which country has the highest number of successful campaigns?
![image](https://github.com/user-attachments/assets/0ba7006c-be14-4c12-8bf0-0a4aa2f02f55)
- The United States ranks first of two ranking boards about metrics. This result is expected, because The United States is famous for its Internet and Streaming Platforms. These platforms not only help increase user engagement, but also share the clips - campaigns which boost the fundraising success
Which countries have  high success rate despite  low number of campaigns ?
- Mexico, Singapore, Luxembourg achieved high success rates 

5. Which year had the highest success rates ?

![image](https://github.com/user-attachments/assets/06eeb368-427e-4acd-94b9-322992e4c159)

- 2009 - 2013: The rates remained stable between **46** and **50%**.
- 2014 - 2016: The launched projects in Kickstarter increased dramatically like 2011, but showing the downtrend in success rates.
    - 2014: Dropped to **35%**, although number projects increased by 1.5x compared to 2013
    - 2015: Low-water mark - **32%**
    - 2016: Slight recover to **38.51%**
- 💡The sharp rise in launched projects in Kickstarter, after 2011 many projects lacked of innovation and break-thourhg leading to higher failure rates.

6. Which month has the highest successful projects ?
![image](https://github.com/user-attachments/assets/87b2b2eb-7d34-44ed-a55e-e0f84335506c)
- July (2014) , March (2015 - 2016) had more successfull projects than other months.

PowerBi - Visualization
