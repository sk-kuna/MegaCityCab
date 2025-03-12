document.addEventListener("DOMContentLoaded", function () {
  // FAQ Toggle functionality
  const faqItems = document.querySelectorAll(".faq-item");

  faqItems.forEach((item) => {
    const question = item.querySelector(".faq-question");
    question.addEventListener("click", () => {
      // Close other items
      faqItems.forEach((otherItem) => {
        if (otherItem !== item && otherItem.classList.contains("active")) {
          otherItem.classList.remove("active");
        }
      });
      // Toggle current item
      item.classList.toggle("active");
    });
  });

  // Support Form Submission
  const supportForm = document.getElementById("supportForm");
  supportForm.addEventListener("submit", function (e) {
    e.preventDefault();

    const formData = new FormData(this);

    fetch("../SupportServlet", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          alert(
            "Your message has been sent successfully. Our team will contact you soon."
          );
          supportForm.reset();
        } else {
          alert("Failed to send message. Please try again.");
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred. Please try again later.");
      });
  });
});

function openLiveChat() {
  // Implement live chat functionality
  alert("Live chat feature coming soon!");
}
