;; title: ojcoin
;; version: 1.0.0
;; summary: OJCoin - A fungible token implementation on Stacks blockchain
;; description: OJCoin is a SIP-010 compliant fungible token with standard transfer,
;;              mint, and burn capabilities. The contract includes role-based access
;;              control with a contract owner who can mint new tokens.

;; traits
;;
;; This contract implements the SIP-010 Fungible Token Standard
;; https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md

;; token definitions
;;
(define-fungible-token ojcoin)

;; constants
;;
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))

;; Maximum supply: 1 billion OJCoins (with 6 decimals)
(define-constant max-supply u1000000000000000)

;; data vars
;;
(define-data-var token-name (string-ascii 32) "OJCoin")
(define-data-var token-symbol (string-ascii 10) "OJC")
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://ojcoin.io/token-metadata.json"))
(define-data-var token-decimals uint u6)

;; data maps
;;

;; public functions
;;

;; SIP-010 Standard Functions

;; Transfer tokens from sender to recipient
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (try! (ft-transfer? ojcoin amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; Get token name
(define-read-only (get-name)
  (ok (var-get token-name))
)

;; Get token symbol
(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

;; Get token decimals
(define-read-only (get-decimals)
  (ok (var-get token-decimals))
)

;; Get balance of an account
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance ojcoin account))
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (ft-get-supply ojcoin))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Additional Functions

;; Mint new tokens (only contract owner)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (<= (+ (ft-get-supply ojcoin) amount) max-supply) (err u104))
    (ft-mint? ojcoin amount recipient)
  )
)

;; Burn tokens from sender's account
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (>= (ft-get-balance ojcoin tx-sender) amount) err-insufficient-balance)
    (ft-burn? ojcoin amount tx-sender)
  )
)

;; Set token URI (only contract owner)
(define-public (set-token-uri (new-uri (optional (string-utf8 256))))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (var-set token-uri new-uri))
  )
)

;; read only functions
;;

;; Check if an address is the contract owner
(define-read-only (is-contract-owner (address principal))
  (is-eq address contract-owner)
)

;; Get maximum supply
(define-read-only (get-max-supply)
  (ok max-supply)
)

;; private functions
;;
