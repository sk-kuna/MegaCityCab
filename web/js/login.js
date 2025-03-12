function toggleForm(type) {
  const loginForm = document.getElementById("loginForm");
  const registerForm = document.getElementById("registerForm");

  if (type === "register") {
    loginForm.style.display = "none";
    registerForm.style.display = "block";
  } else {
    loginForm.style.display = "block";
    registerForm.style.display = "none";
  }
}
