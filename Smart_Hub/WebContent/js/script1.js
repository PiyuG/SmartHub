function toggleDropdown() {
            document.getElementById('profileDropdown').classList.toggle('show');
        }
        window.onclick = function(event) {
            if (!event.target.closest('.profile')) {
                document.getElementById('profileDropdown').classList.remove('show');
            }
        }
        function toggleDropdown1(menuId, iconId, element) {
            var dropdown = document.getElementById(menuId);
            var icon = document.getElementById(iconId);
            
            if (dropdown.style.display === "block") {
                dropdown.style.display = "none";
                icon.textContent = "+";
            } else {
                dropdown.style.display = "block";
                icon.textContent = "-";
            }

            setActive(element);
        }

        function setActive(element) {
            // Remove 'active' class from all menu items
            document.querySelectorAll(".list-group-item").forEach(item => item.classList.remove("active"));

            // Add 'active' class to the clicked item
            element.classList.add("active");
        }
        function showLoaderAndNavigate(page) {
        var loader = document.getElementById('loader');
        var content = document.getElementById('content');

        // Show the loader
        loader.classList.add('show');
        content.classList.remove('show'); // Hide content smoothly

        setTimeout(() => {
            // Fetch the page content and update the content div
            fetch(page)
                .then(response => response.text())
                .then(data => {
                    content.innerHTML = data; // Load new content dynamically
                    loader.classList.remove('show'); // Hide loader
                    setTimeout(() => {
                        content.classList.add('show'); // Show content smoothly
                    }, 100);
                })
                .catch(error => {
                    console.error('Error loading the page:', error);
                    loader.classList.remove('show');
                });
                
            }, 400);
        }
        function toggleNotification() {
            document.getElementById('notificationDropdown').classList.toggle('show');
        }
        window.onclick = function(event) {
            if (!event.target.closest('.notification')) {
                document.getElementById('notificationDropdown').classList.remove('show');
            }
        };
        window.onload = function () {
            showLoaderAndNavigate('/Smart_Hub/jsp_pages/admin/index.jsp');  // Load index.html automatically when the page opens
        };