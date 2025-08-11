with
customer_orders as (
    select * from {{ ref('int_customer_orders')}}
),


paid_orders as (
    select * from {{ ref("int_paid_orders")}}
),


int_paid_orders_customers as (
       select * from {{ ref("int_paid_orders_customers")}}
)


select
    p.*,
    row_number() over (order by p.order_id) as transaction_seq,
    row_number() over (partition by c.customer_id order by p.order_id) as customer_sales_seq,
    
      case  
      when (
      rank() over (
      partition by c.customer_id
      order by order_placed_at, p.order_id
      ) = 1
    ) then 'new'
    else 'return' end as nvsr,
    
    -- customer lifetime value
    sum(total_amount_paid) over (
      partition by customer_id
      order by order_placed_at
      ) as customer_lifetime_value,

    -- first day of sale
    first_value(order_placed_at) over (
      partition by customer_id
      order by order_placed_at
      ) as fdos
    
    from paid_orders p
    left join customer_orders as c using (c.customer_id)
    
    left outer join int_paid_orders_customers x on x.order_id = p.order_id

    order by order_id