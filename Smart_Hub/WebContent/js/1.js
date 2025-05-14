function toggleDropdown() {
            document.getElementById('profileDropdown').classList.toggle('show');
}
window.onclick = function(event) {
    if (!event.target.closest('.profile')) {
        document.getElementById('profileDropdown').classList.remove('show');
    }
}

function showLoaderAndNavigate(url) {
    document.getElementById("loader").classList.add("show");
    setTimeout(() => {
        window.location.href = url;
    }, 1000); // 1-second delay
}

function toggleNotification() {
    document.getElementById('notificationDropdown').classList.toggle('show');
}


function toggleDropdown1(dropdownId, iconId, element) {
    let dropdown = document.getElementById(dropdownId);
    let icon = document.getElementById(iconId);
	console.log(dropdown)
    // Close all other dropdowns
    document.querySelectorAll(".dropdown-list").forEach(list => list.style.display = "none");
    document.querySelectorAll(".menu-item span").forEach(icon => icon.innerText = "+");

    // Toggle selected dropdown
    let isOpen = dropdown.style.display === "block";
    dropdown.style.display = isOpen ? "none" : "block";
    icon.innerText = isOpen ? "+" : "-";

    // Set the active sidebar item
    setActiveSidebar(element);

    // Store state in localStorage
    if (!isOpen) {
        localStorage.setItem("activeDropdown", dropdownId);
    } else {
        localStorage.removeItem("activeDropdown");
    }
}

// Restore active dropdown on page load
document.addEventListener("DOMContentLoaded", function () {
    let activeDropdown = localStorage.getItem("activeDropdown");
    console.log(activeDropdown);
    if (activeDropdown) {
        let dropdown = document.getElementById(activeDropdown);
        let icon = dropdown.previousElementSibling.querySelector("span");
        if (dropdown && icon) {
            dropdown.style.display = "block";
            icon.innerText = "-";
        }
    }
});

function setActiveSidebar(element) {
    // Remove active class from all menu items
    document.querySelectorAll(".list-group-item").forEach(item => {
        item.classList.remove("active");
    });

    // Add active class to the clicked item
    element.classList.add("active");

    // Store the active menu item in localStorage
    localStorage.setItem("activeSidebar", element.innerText.trim());
}

// Restore active sidebar item on page load
document.addEventListener("DOMContentLoaded", function () {
    let activeSidebar = localStorage.getItem("activeSidebar");
    if (activeSidebar) {
        document.querySelectorAll(".list-group-item").forEach(item => {
            if (item.innerText.trim() === activeSidebar) {
                item.classList.add("active");
            }
        });
    }
});

window.onclick = function(event) {
    if (!event.target.closest('.notification')) {
        document.getElementById('notificationDropdown').classList.remove('show');
    }
};