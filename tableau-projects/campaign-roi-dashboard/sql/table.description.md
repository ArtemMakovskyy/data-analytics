## Архітектура даних

### **Вхідні таблиці (BigQuery)**

|**Таблиця**|**Опис**|**Ключові поля**|
|---|---|---|
|**cost_table**|Витрати на рекламу, покази та кліки|`date`, `app_id`, `media_source`, `campaign_id`|
|**non_org_installs_report**|Встановлення додатку з рекламних джерел|`advertising_id`, `install_date`, `app_id`|
|**ad_revenue_raw**|Дохід від реклами всередині застосунку|`advertising_id`, `event_revenue_usd`|
|**in_app_events_report**|Покупки, підписки, in‑app події|`advertising_id`, `event_revenue_usd`|

### **Вибрані поля та використання**

#### **ad_revenue_raw**

- `event_date` — дата доходу (**TIMESTAMP**)
    
- `app_id` — ідентифікатор застосунку
    
- `media_source` — рекламний канал:
    
    - `googleadwords_int` — кампанії Google Ads
        
    - `other` —  без кампаній
        
    - `unknown` —  без кампаній
        
- `campaign_id` — код рекламної кампанії (лише для `googleadwords_int`)
    
- `campaign_name` — назва рекламної кампанії
    
- `event_revenue_usd` — дохід від реклами
    

> Використовується для аналізу **Ad Revenue** у розрізі кампаній Google Ads. Джерела `other` та `unknown` не мають кампаній, тому не враховуються у маркетинговій вітрині.

#### **cost_table**

- `date` — дата витрат (**STRING → PARSE_DATE**)
    
- `app_id` — ідентифікатор застосунку
    
- `media_source` — рекламний канал (`googleadwords_int`)
    
- `campaign_id` — код рекламної кампанії
    
- `campaign` — використовується як `campaign_name`
    
- `cost_usd` — витрати в доларах США
    
- `impressions` — кількість показів реклами
    
- `clicks` — кількість кліків
    

> Використовується для аналізу **витрат на кампанії Google Ads** у розрізі днів і кампаній.

Дата має стрінг тип, маємо перетворити в дату
#### **non_org_installs_report**

- `install_date` — дата встановлення (**TIMESTAMP**)
    
- `app_id` — ідентифікатор застосунку
    
- `media_source` — рекламний канал (`googleadwords_int`, `other`, `unknown`)
    
- `campaign_id` — код рекламної кампанії (лише для `googleadwords_int`)
    
- `campaign_name` — назва рекламної кампанії
    
- `advertising_id` — унікальний ідентифікатор користувача
    

> Використовується для аналізу **кількості встановлень (Installs)** у розрізі кампаній Google Ads. 

#### **in_app_events_report**

- `event_date` — дата події (**TIMESTAMP**)
    
- `app_id` — ідентифікатор застосунку
    
- `media_source` — рекламний канал (`googleadwords_int`, `other`, `unknown`)
    
- `campaign_id` — код рекламної кампанії (лише для `googleadwords_int`)
    
- `campaign_name` — назва рекламної кампанії
    
- `event_revenue_usd` — дохід від події (покупки або підписки)
    

> Використовується для аналізу **IAP Revenue (дохід від внутрішніх подій)** у розрізі кампаній Google Ads. 

За допомогою UNION ALL обєднуємо всі таблиці в одну
