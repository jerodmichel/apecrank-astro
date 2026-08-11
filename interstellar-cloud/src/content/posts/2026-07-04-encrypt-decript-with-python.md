---
title: "Simple Message Encoder and Decoder in Python"
pubDatetime: 2014-01-01T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "cryptography", "fernet", "encryption", "decryption", "code snippet"]
description: "A quick note and code snippet demonstrating how to generate keys and encrypt or decrypt messages using Python's cryptography library."
---

```python
#%%
from cryptography.fernet import Fernet

def write_key():
    """
    Generates a key and save it into a file
    """
    key = Fernet.generate_key()
    with open("key.key", "wb") as key_file:
        key_file.write(key)
        
def load_key():
    """
    Loads the key from the current directory named `key.key`
    """
    return open("key.key", "rb").read()

# generate and write a new key
write_key()

# load the previously generated key
key = load_key()

#%%
message = "Hello World!".encode()

# initialize the Fernet class
f = Fernet(key)

#%%
# encrypt the message
encrypted = f.encrypt(message)

#%%
# print how it looks
print(encrypted)

#%%
decrypted_encrypted = f.decrypt(encrypted)
print(decrypted_encrypted)
#%%
```

**Build a simple message encoder:**

```python
from cryptography.fernet import Fernet

def write_key():
    """
    This generates a key and saves it into a file
    """
    key = Fernet.generate_key()
    with open("key.key", "wb") as key_file:
        key_file.write(key)
        
def load_key():
    """
    This loads the key from the current directory named `key.key`
    """
    return open("key.key", "rb").read()

def encrypt_message(message):
    """
    Encrypts a message
    """
    key = load_key()
    encoded_message = message.encode()
    f = Fernet(key)
    encrypted_message = f.encrypt(encoded_message)

    print(encrypted_message)

if __name__ == "__main__":
    encrypt_message("message to encrypt")


Output:
b'gAAAAABgh68zeqW0pQgDTZlZs-1ezzDCAHkz5SnPYKuFIrLJ8bgwHuZoJONFMShSBKLP1Xh5cjf9wLB_TbluMQ1MNRpNDs5n7UlSVa7obfaHtfCnc_FWuzA='
```

**Build a simple decoder:**

```python
from cryptography.fernet import Fernet

def load_key():
    """
    This loads the key from the current directory named `key.key`
    """
    return open("key.key", "rb").read()

def decrypt_message(encrypted_message):
    """
    Decrypts an encrypted message
    """
    key = load_key()
    f = Fernet(key)
    decrypted_message = f.decrypt(encrypted_message)

    print(decrypted_message.decode())

if __name__ == "__main__":
    decrypt_message(b'gAAAAABgh68zeqW0pQgDTZlZs-1ezzDCAHkz5SnPYKuFIrLJ8bgwHuZoJONFMShSBKLP1Xh5cjf9wLB_TbluMQ1MNRpNDs5n7UlSVa7obfaHtfCnc_FWuzA=')


Output:
message to encrypt
```