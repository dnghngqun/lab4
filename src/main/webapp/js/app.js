// Cart localStorage functions
function saveCartToLocalStorage(cart) {
    localStorage.setItem('cart', JSON.stringify(cart));
}

function getCartFromLocalStorage() {
    const cart = localStorage.getItem('cart');
    return cart ? JSON.parse(cart) : [];
}

function syncCartWithServer() {
    const localCart = getCartFromLocalStorage();
    console.log('Syncing cart with server:', localCart);

    if (localCart.length > 0) {
        return fetch('cart/sync', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(localCart)
        })
            .then(response => response.json())
            .then(data => {
                console.log('Sync response:', data);
                if (data.status === 'success') {
                    updateCartBadge();
                }
                return data;
            })
            .catch(error => {
                console.error('Sync error:', error);
                throw error;
            });
    } else {
        return Promise.resolve({status: 'success', cartSize: 0});
    }
}
// Modal functions
function openAddModal() {
    document.getElementById('addModal').style.display = 'block';
}

function openEditModal(id, name, price, description, imageUrl) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editPrice').value = price;
    document.getElementById('editDescription').value = description;
    document.getElementById('editImageUrl').value = imageUrl;
    document.getElementById('editModal').style.display = 'block';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// Updated add to cart function
function addToCart(productId, productName) {
    const localCart = getCartFromLocalStorage();
    const product = {
        id: productId,
        name: productName,
        timestamp: Date.now()
    };
    localCart.push(product);
    saveCartToLocalStorage(localCart);
    updateCartBadge();

    fetch('cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'productId=' + productId
    })
        .then(response => {
            if (response.ok) {
                showNotification('Đã thêm ' + productName + ' vào giỏ hàng!', 'success');
            } else {
                const updatedCart = localCart.filter(item =>
                    !(item.id == productId && item.timestamp === product.timestamp)
                );
                saveCartToLocalStorage(updatedCart);
                updateCartBadge();
                showNotification('Có lỗi xảy ra!', 'error');
            }
        })
        .catch(error => {
            const updatedCart = localCart.filter(item =>
                !(item.id == productId && item.timestamp === product.timestamp)
            );
            saveCartToLocalStorage(updatedCart);
            updateCartBadge();
            showNotification('Có lỗi xảy ra!', 'error');
        });
}

// Remove from cart
function removeFromCart(index) {
    const localCart = getCartFromLocalStorage();
    localCart.splice(index, 1);
    saveCartToLocalStorage(localCart);
    updateCartBadge();

    fetch(`cart/remove?index=${index}`, {
        method: 'GET'
    }).then(() => {
        location.reload();
    });
}

// Clear cart
function clearCart() {
    if (confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')) {
        localStorage.removeItem('cart');
        updateCartBadge();

        fetch('cart/clear', {
            method: 'GET'
        }).then(() => {
            location.reload();
        });
    }
}

// Update cart badge
function updateCartBadge() {
    const localCart = getCartFromLocalStorage();
    const cartBadge = document.querySelector('.cart-badge');
    if (cartBadge) {
        cartBadge.textContent = localCart.length;
    }
}

// Notification function
function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type}`;
    notification.style.position = 'fixed';
    notification.style.top = '20px';
    notification.style.right = '20px';
    notification.style.zIndex = '9999';
    notification.style.animation = 'slideUp 0.3s ease-out';
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Close modals when clicking outside
window.onclick = function(event) {
    const modals = document.getElementsByClassName('modal');
    for (let modal of modals) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
}

// Auto-logout warning
let warningShown = false;
setInterval(() => {
    if (!warningShown) {
        warningShown = true;
        showNotification('Phiên làm việc sắp hết hạn!', 'error');
    }
}, 50000);

// Sync cart when page loads
document.addEventListener('DOMContentLoaded', function() {
    updateCartBadge();

    // Chỉ sync nếu user đã login
    const user = document.querySelector('.nav-links a[href="logout"]');
    if (user) {
        syncCartWithServer();
    }
});

// Sync cart when login success (call this after login)
function onLoginSuccess() {
    syncCartWithServer();
}