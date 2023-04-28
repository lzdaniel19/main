/**
 * TODO:
 * - Tesztelni
 */


;(function(window, angular) {

  'use strict';

  // Application module
  angular.module('app', ['ui.router', 'app.common'])

  /* Application config */
  .config([
    '$stateProvider', 
    '$urlRouterProvider', 
    function($stateProvider, $urlRouterProvider) {

      $stateProvider
        .state('home', {
          url: '/',
          templateUrl: './html/home.html'
        })
        .state('shop', {
          url: '/shop',
          templateUrl: './html/shop.html',
          controller: 'shopController'
        })
        .state('contact', {
          url: '/contact',
          templateUrl: './html/contact.html'
        })
        .state('blog', {
          url: '/blog',
          templateUrl: './html/blog.html'
        })
        .state('blog2', {
          url: '/blog2',
          templateUrl: './html/blog2.html'
        })
        .state('login', {
          url: '/login',
          templateUrl: './html/login.html',
          controller: 'loginController'  
        })
        .state('register', {
          url: '/register',
          templateUrl: './html/register.html',
          controller: 'registerController'  
        })
        .state('cart', {
          url: '/cart',
          templateUrl: './html/cart.html',
          controller: 'cartController'  
        })
        .state('order', {
          url: '/order',
          templateUrl: './html/order.html',
          controller: 'orderController'  
        });
      
      $urlRouterProvider.otherwise('/');
    }
  ])

  // Application run
  .run([
    '$state',
    '$transitions',
    '$rootScope',
    '$timeout',
    'util',
    ($state, $transitions, $rootScope, $timeout, util) => {

      // Set global variables
      $rootScope.state = {
        id: null, 
        prev: null,
        base: ['home','contact','blog','blog2','shop'], 
        available : $state.get()
                          .map(state => state.name)
                          .filter(name => name !== '')
      };

      // Get user/cart saved properties
      getProperties();

      // On before transaction
      $transitions.onBefore({}, (transition) => {
        return $timeout(() => {
          if ($rootScope.state.id === null) {
            if (!$rootScope.state.base.includes(transition.to().name)) 
              return transition.router.stateService.target('home');
          }

          // Set state properties
          $rootScope.state.prev = $rootScope.state.id;
          $rootScope.state.id   = transition.to().name;

          // Each state add/remove to body class state
          [...$rootScope.state.available].forEach((state) => {
            if (state === $rootScope.state.id)
                  document.body.classList.add(state);
            else  document.body.classList.remove(state);
          });
          return true;
        });
      });

      // Logout
      $rootScope.logout = function() {
        if (confirm('Biztosan kijelentkezik?') == true) {
          $rootScope.user = null;
          $rootScope.cart = [];
          $rootScope.$applyAsync();
          localStorage.removeItem("user");
          localStorage.removeItem("cart");
          if (!$rootScope.state.base.includes($rootScope.state.id))
            $state.go('home');
        }
      }

      // Check shopping cart exist
      $rootScope.getCart = function() {
        if ($rootScope.cart.length) {
          $state.go('cart');
        }
      }

      // Check inputs data value valid
      $rootScope.isDataValid = () => {
        let inputs = document.querySelectorAll('input[required], textarea[required]');
        if (inputs.length) {
          let btnSubmit   = document.getElementById('submit'),
              isDisabled  = false;
          for(let i=0; i<inputs.length; i++) {
            let input = inputs[i],
                value = input.value;
              if (util.isString(value)) 
                    value = value.trim();
              else  value = ''; 
              switch(input.id) {
                case 'telefonszam':
                  isDisabled = !util.isPhoneNumber(value);
                  break;
                case 'email':
                  isDisabled = !util.isEmail(value);
                  break;
                case 'jelszo':
                case 'jelszo2':
                case 'password':
                case 'password2':
                  isDisabled = !util.isPassword(value);
                  if (!isDisabled && ['jelszo2','password2'].includes(input.id)) {
                    let pass = document.querySelector(input.id === 'jelszo2' ? 'jelszo' : 'password');
                    if (pass) {
                      let value2 = pass.value;
                      if (util.isString(value2)) 
                            value2 = value2.trim();
                      else  value2 = ''; 
                      isDisabled = value !== value2;
                    }
                  }
                  break;
                default:
                  isDisabled = value.length === 0;
              }
              if (isDisabled) break;
          }
          btnSubmit.disabled = isDisabled;
        }
      };

      // Get user/cart saved properties
      function getProperties() {

        // Each keys
        ["user", "cart"].forEach(key => {
          let data = localStorage.getItem(key);
          if (util.isJson(data))
            data = JSON.parse(data);
          if (key === "cart" && !util.isArray(data))
            data = [];
          $rootScope[key] = data;
        });
        
        // Apply change
        $rootScope.$applyAsync();
      }
    }
  ])

  // Shop controller
  .controller('shopController', [
    '$rootScope',
    '$scope',
    '$state',
    'http',
    function($rootScope, $scope, $state, http) {
      
      // Set products type filter
      $scope.dataFilter = null;

      // Get products
      http.request({
        url: "./php/termek.php",
        method: 'GET'
      })
      .then(data => {
        $scope.data = data;
        $scope.dataFilter = data.tipus[0].tipus_path;
        $scope.$applyAsync();
      });

      // Products filter
      $scope.termekFilter = function(event) {
        let element = event.currentTarget;
        $scope.dataFilter = element.id;
        $scope.$applyAsync();
      }

      // Add product to cart
      $scope.toCart = function(data) {
        if ($rootScope.user) {
          $rootScope.cart.push(data);
          $rootScope.$applyAsync();
          localStorage.setItem("cart", JSON.stringify($rootScope.cart));
          if (!confirm("A termék a kosárba került!\n\nFolytatja a vásárlást?")) {
            $state.go('cart');
          }
        } else if (confirm("Vásárlás előtt jelentkezzen be, vagy regisztráljon oldalunkon!" +
                           "\n\nBejelentkezik?")) {
          $state.go('login');
        }
      }
    }
  ])

  // Login controller
  .controller('loginController', [
    '$state',
    '$rootScope',
    '$scope',
    'http',
    function($state, $rootScope, $scope, http) {
      
      // Create model
      $scope.model = {
        email : null,
        jelszo: null      
      };

      // Login
      $scope.login = function() {

        // Check user
        http.request({
          url: "./php/login.php",
          method: 'POST',
          data: $scope.model
        })
        .then(data => {
          localStorage.setItem("user", JSON.stringify(data));
          $rootScope.user = data;
          $rootScope.$applyAsync();
          if ($scope.state.prev && $rootScope.state.base.includes($scope.state.prev))
                $state.go($scope.state.prev);
          else  $state.go('shop');
        })
        .catch(error => {
          alert(error);
        });
      };

      // Cancel
      $scope.cancel = function() {
        if ($scope.state.prev && $rootScope.state.base.includes($scope.state.prev))
              $state.go($scope.state.prev);
        else  $state.go('shop');
      };
    }
  ])

  // Register controller
  .controller('registerController', [
    '$state',
    '$rootScope',
    '$scope',
    'http',
    function($state, $rootScope, $scope, http) {
      
      // Create model
      $scope.model = {
        email       : null,
        jelszo      : null,
        nev         : null,
        lakcim      : null,
        telefonszam : null,
        jelszo2     : null
      }

      // Register
      $scope.register = function() {

        // Add user if not exist
        http.request({
          url: "./php/register.php",
          method: 'POST',
          data: $scope.model
        })
        .then(data => {
          $rootScope.user = {
            id: data.lastInsertId,
            nev: $scope.model.nev,
            lakcim: $scope.model.lakcim,
            telefonszam: $scope.model.telefonszam
          }
          $rootScope.$applyAsync();
          localStorage.setItem("user", JSON.stringify($rootScope.user));
          if ($scope.state.prev && $rootScope.state.base.includes($scope.state.prev))
                $state.go($scope.state.prev);
          else  $state.go('shop');
        })
        .catch(error => {
          alert(error);
        });
      }

      // Cancel
      $scope.cancel = function() {
        if ($scope.state.prev && $rootScope.state.base.includes($scope.state.prev))
              $state.go($scope.state.prev);
        else  $state.go('shop');
      }
    }
  ])

  // Cart controller
  .controller('cartController', [
    '$rootScope',
    '$scope',
    '$state',
    '$timeout',
    'http',
    'util',
    function($rootScope, $scope, $state, $timeout, http, util) {
      
      // Set helper
      $scope.helper = {
        kep       : 'Termék',
        megnevezes: '',
        url_id    : 'Márka',
        leiras    : 'Leírás',
        tipus     : 'Típus',
        meret     : 'Méret',
        darab     : 'Darab',
        ar        : 'Alapár',
        total     : 'Összeg',
        size      : null
      };

      // Create model
      $scope.model = util.cloneVariable($rootScope.user);
      if (util.isObject($scope.model)) {
        $scope.model.megjegyzes   = '';
        $scope.model.fizetesimod  = 'C';
      }

      // Confirm order
      $scope.confirm = function() {

        // Set order
        let order = {
          user_id       : $rootScope.user.id,
          nev           : $scope.model.nev,
          szallitasicim : $scope.model.lakcim,
          telefonszam   : $scope.model.telefonszam,
          megjegyzes    : $scope.model.megjegyzes,
          fizetesimod   : $scope.model.fizetesimod,
          osszeg        : $scope.sumCart,
          items         : []
        };

        // Set order items
        for(let i=0; i < $rootScope.cart.length; i++) {
          order.items.push(util.objFilterByKeys($rootScope.cart[i], [
            'termek_id', 'size', 'darab', 'ar', 'total'
          ]));
        }

        // Set order
        http.request({
          url: "./php/setOrder.php",
          method: 'POST',
          data: order
        })
        .then(data => {
          alert("A rendelését rögzítettük!");
          $rootScope.cart = [];
          localStorage.removeItem("cart");
          $rootScope.$applyAsync();
          $state.go('shop');
        })
        .catch(error => {
          alert(error);
        });
      };

      // Delete item
      $scope.deleteItem = (event) => {
        if (confirm('Biztosan eltávolítja a terméket a kosárból?')) {
          let element = event.currentTarget,
              parent  = element.closest('tr'),
              index   = parseInt(parent.getAttribute('data-index'));
          $rootScope.cart.splice(index, 1);
          
          if (!$rootScope.cart.length) {
            localStorage.removeItem("cart");
            $state.go($scope.state.prev);
          }
          sumTotal();
        }
      };

      // Sum total
      function sumTotal() {
        $scope.sumCart = 0;
        for(let i=0; i < $rootScope.cart.length; i++) {
          $scope.sumCart += $rootScope.cart[i].total;
        };
        $scope.$applyAsync();
        localStorage.setItem("cart", JSON.stringify($rootScope.cart));
      }

      // Quantity changed 
      $scope.changeQuantity = () => {
        for(let i=0; i < $rootScope.cart.length; i++) {
          $rootScope.cart[i].total =  $rootScope.cart[i].darab *
                                      $rootScope.cart[i].ar;
        }
        sumTotal();
      }

      // Sum total
      sumTotal();

      // Reset asynchronity 
      $timeout(() => {

        // Check inputs data value valid
        $rootScope.isDataValid();
      });
    }
  ])

  // Order controller
  .controller('orderController', [
    '$rootScope',
    '$scope',
    'http',
    'util',
    function($rootScope, $scope, http) {
      
      // Set helpers
      $scope.helper1 = {
        id            : 'Azon.',
        datum         : 'Dátum',
        nev           : 'Megrendelő',
        szallitasicim : 'Cím',
        telefonszam   : 'Telefon',
        megjegyzes    : 'Megjegyzés',
        fizetesimod   : 'Fiz.mód',
        osszeg        : 'Összeg'
      };

      $scope.helper2 = {
        kep           : 'Termék',
        megnevezes    : '',
        url_id        : 'Márka',
        leiras        : 'Leírás',
        tipus         : 'Típus',
        meret         : 'Méret',
        darab         : 'Darab',
        ar            : 'Alapár',
        osszeg        : 'Összeg'
      };

      // Get user order(s)
      http.request({
        url: "./php/getOrder.php",
        method: 'POST',
        data: $rootScope.user.id
      })
      .then(data => {
        $scope.data     = data;
        $scope.pointer  = data && data.length ? 0 : -1;
        $scope.$applyAsync();
      })
      .catch(error => {
        alert(error);
      });

      // Order select
      $scope.orderSelect = (event) => {
        let element = event.currentTarget;
        $scope.pointer = parseInt(element.getAttribute('data-index'));
        $scope.$applyAsync();
      }
    }
  ]);
  
})(window, angular);