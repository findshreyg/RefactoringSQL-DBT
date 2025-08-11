with base_orders as (

   select * from {{ ref('stg_jaffle_shop__orders') }}
),

base_customers as (
    
    select *
    from {{ ref('stg_jaffle_shop__customers')}}

),

nested_payments as (
    select * from {{ ref("int_nested_payments")}}
),


paid_orders as (

    select 

        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        customer_first_name,
        customer_last_name
    
    from base_orders as orders

    left join nested_payments as p
    
    on orders.order_id = p.order_id
    
    left join base_customers as c 
    
    on orders.customer_id = c.customer_id
    
)

select * from paid_orders
