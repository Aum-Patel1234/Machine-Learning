const port = '8080';
fetch(`http://127.0.0.1:${port}/get_locations`, {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
})
.then((res) => res.json())
.then((res) => {
    const location = document.querySelector("#location");
    console.log(res);
    console.log(res['data_columns']);
    res['data_columns'].forEach((loc)=>{
      console.log(loc);
      let str = `
        <option value="${loc}">${loc.charAt(0).toUpperCase() + loc.slice(1)}</option>
      `;
      const newElement = document.createElement("option");
      newElement.innerHTML = str;
      location.appendChild(newElement);
    })
})  
.catch((err) => {
    console.log(err);
});

document.querySelector("#predictForm").addEventListener('submit', async (event) => {
  event.preventDefault(); // Prevent form from reloading the page

  const location = document.querySelector('#location').value;
  const sqft = document.querySelector('#sqft').value;
  const bhk = document.querySelector('#bhk').value;
  const bath = document.querySelector('#bath').value;

  const url = `http://127.0.0.1:${port}/predict_price`;

  const formData = new FormData();
  formData.append('location', location);
  formData.append('sqft', sqft);
  formData.append('bhk', bhk);
  formData.append('bath', bath);

  try {
      const response = await fetch(url, {
          method: 'POST',
          body: formData,
      });

      if (response.ok) {
          const result = await response.json();
          // console.log(result); 
          document.querySelector("#result").innerHTML = `<h2>${result['estimated_price']} Lakhs</h2>`;
      } else {
          console.error('Error:', response.statusText);
      }
  } catch (error) {
      console.error('Error:', error);
  }
});