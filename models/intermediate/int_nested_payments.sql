with payments as(

    select * from {{ ref("stg_stripe__payments")}}
),

nested_payments as (
     select 
            order_id, 
            max(payment_created_at) as payment_finalized_date, 
            sum(payment_amount) as total_amount_paid
        
        from payments
        
        where payment_status <> 'fail'

        group by 1
)

select * from nested_payments