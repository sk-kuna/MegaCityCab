<%@page contentType="text/html" pageEncoding="UTF-8"%> <% if
(session.getAttribute("userId") == null) {
response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Support - MegaCity Cab</title>
    <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/customer.css" />
    <link rel="stylesheet" href="../css/support.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
    <div class="customer-container">
      <%@ include file="includes/sidebar.jsp" %>

      <div class="main-content">
        <div class="support-content">
          <h2>Customer Support</h2>

          <div class="support-grid">
            <!-- FAQ Section -->
            <div class="faq-section">
              <h3>Frequently Asked Questions</h3>
              <div class="faq-list">
                <div class="faq-item">
                  <div class="faq-question">
                    <h4>How do I book a ride?</h4>
                    <i class="fas fa-chevron-down"></i>
                  </div>
                  <div class="faq-answer">
                    Click on "Book a Ride" in the sidebar, enter your pickup and
                    drop-off locations, select your preferences, and confirm
                    your booking.
                  </div>
                </div>

                <div class="faq-item">
                  <div class="faq-question">
                    <h4>How do I cancel my booking?</h4>
                    <i class="fas fa-chevron-down"></i>
                  </div>
                  <div class="faq-answer">
                    Go to "My Rides", find your booking, and click the cancel
                    button. Cancellation fees may apply depending on the timing.
                  </div>
                </div>

                <div class="faq-item">
                  <div class="faq-question">
                    <h4>What payment methods are accepted?</h4>
                    <i class="fas fa-chevron-down"></i>
                  </div>
                  <div class="faq-answer">
                    We accept cash, credit/debit cards, and digital wallets for
                    your convenience.
                  </div>
                </div>
              </div>
            </div>

            <!-- Contact Support Section -->
            <div class="contact-support">
              <h3>Contact Support</h3>
              <form id="supportForm" action="../SupportServlet" method="POST">
                <div class="form-group">
                  <label>Subject</label>
                  <select name="subject" required>
                    <option value="">Select a topic</option>
                    <option value="booking">Booking Issues</option>
                    <option value="payment">Payment Problems</option>
                    <option value="driver">Driver Related</option>
                    <option value="other">Other</option>
                  </select>
                </div>

                <div class="form-group">
                  <label>Message</label>
                  <textarea
                    name="message"
                    rows="5"
                    required
                    placeholder="Describe your issue..."
                  ></textarea>
                </div>

                <div class="form-group">
                  <label>Booking ID (if applicable)</label>
                  <input
                    type="text"
                    name="bookingId"
                    placeholder="Enter booking ID"
                  />
                </div>

                <button type="submit" class="submit-btn">
                  <i class="fas fa-paper-plane"></i> Send Message
                </button>
              </form>
            </div>
          </div>

          <!-- Quick Contact Options -->
          <div class="quick-contact">
            <h3>Quick Contact</h3>
            <div class="contact-options">
              <a href="tel:+94112345678" class="contact-card">
                <i class="fas fa-phone"></i>
                <div class="contact-info">
                  <h4>Call Us</h4>
                  <p>+94 11 234 5678</p>
                </div>
              </a>

              <a href="mailto:support@megacitycab.com" class="contact-card">
                <i class="fas fa-envelope"></i>
                <div class="contact-info">
                  <h4>Email Us</h4>
                  <p>support@megacitycab.com</p>
                </div>
              </a>

              <a href="#" class="contact-card" onclick="openLiveChat()">
                <i class="fas fa-comments"></i>
                <div class="contact-info">
                  <h4>Live Chat</h4>
                  <p>Chat with our team</p>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="../js/support.js"></script>
  </body>
</html>
