# Overview

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

- **Small Goal Range [<=1,000]** had the highest success rate at **52.82%** with 25,783 successful projects
- **Medium Goal Range** followed with a **46.5%** success rate, while its total and success projects had double values compared to Small group
- **Large Goal Range** had the highest number of  launched projects, but only rank third in success rate **34.1%**
- **Enterprise-Level Goal Range** only had **13%** success rates, suggesting that high goals are rarely met.
- 💡Small & Medium goal ranges shows the balance  between success rate and scale, which make them ideal and safety for **new people** or **Startups** to reach their funding targets and build a presence in the community.
- 💡Medium & Large goal ranges are suitable for brands that have their own community to increase their project scale, but still have the high success rate for raising investment.
- 💡Small Goal is the safe and effective starting point for newcomers in **KickStarter**


PowerBi - Visualization
