class StripeCheckoutSessionService
  def call(event)
    session = event.data.object
    order = Order.find_by(checkout_session_id: session.id)

    if order
      order.update(status: 'paid', paid_status: true)
      puts "✅ Order ##{order.id} marked as PAID via Stripe Webhook!"
    else
      puts "⚠️ Order not found for session: #{session.id}"
    end
  end
end
