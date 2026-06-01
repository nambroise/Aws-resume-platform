$(document).ready(function () {
    const $win = $(window);
    const $navbar = $('#header');
    const $toggle = $('.toggle-button');
    const width = $navbar.width();

    toggle_onclick($win, $navbar, width);

    $win.resize(function () {
        toggle_onclick($win, $navbar, width);
    });

    $toggle.click(function () {
        $navbar.toggleClass("toggle-left");
    });
});

function toggle_onclick($win, $navbar, width) {
    if ($win.width() <= 768) {
        $navbar.css({ left: `-${width}px` });
    } else {
        $navbar.css({ left: '0px' });
    }
}

// Homepage typing animation
if (document.querySelector('#typed')) {
    new Typed('#typed', {
        strings: [
            'AWS Cloud Engineer',
            'DevOps Engineer'
        ],
        typeSpeed: 50,
        backSpeed: 50,
        loop: true
    });
}

// Smooth scrolling
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const target = document.querySelector(this.getAttribute('href'));

        if (target) {
            e.preventDefault();
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Visitor counter powered by AWS Lambda + DynamoDB
const counterElements = document.querySelectorAll(".counter-number");

async function updateCounter() {
    try {
        const response = await fetch(
            "https://v62m4nlkzpcgiaqmifz35xfsoy0rlsbg.lambda-url.us-east-1.on.aws/",
            {
                method: "GET"
            }
        );

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        const data = await response.text();

        counterElements.forEach(counter => {
            counter.innerHTML = `Views: ${data}`;
        });

    } catch (error) {
        console.error("Visitor counter error:", error);

        counterElements.forEach(counter => {
            counter.innerHTML = "Views: unavailable";
        });
    }
}

updateCounter();
