function generateQRCode(bookingId, pickup, dropoff, amount, bookingTime) {
  // Create QR code data object
  const qrData = {
    bookingId: bookingId,
    pickup: pickup,
    dropoff: dropoff,
    amount: amount,
    bookingTime: bookingTime,
    type: "MegaCityCab-Receipt",
  };

  // Convert to JSON string
  const qrString = JSON.stringify(qrData);

  // Generate QR code
  new QRCode(document.getElementById(`qrcode-${bookingId}`), {
    text: qrString,
    width: 128,
    height: 128,
    colorDark: "#000000",
    colorLight: "#ffffff",
    correctLevel: QRCode.CorrectLevel.H,
  });
}

function downloadQR(bookingId) {
  const canvas = document.querySelector(`#qrcode-${bookingId} canvas`);
  if (canvas) {
    // Convert canvas to data URL
    const dataURL = canvas.toDataURL("image/png");

    // Create download link
    const downloadLink = document.createElement("a");
    downloadLink.href = dataURL;
    downloadLink.download = `receipt-qr-${bookingId}.png`;

    // Trigger download
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
  }
}
