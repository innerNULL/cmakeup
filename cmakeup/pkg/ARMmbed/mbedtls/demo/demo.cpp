/// file: main.cpp
/// date: 2021-04-01


#include "mbedtls/error.h"
#include "mbedtls/pk.h"
#include "mbedtls/ecdsa.h"
#include "mbedtls/rsa.h"
#include "mbedtls/error.h"
#include "mbedtls/entropy.h"
#include "mbedtls/ctr_drbg.h"
#include "mbedtls/platform.h"


int main() {
  const mbedtls_md_info_t *md_info;
  mbedtls_md_context_t md_ctx;
  mbedtls_md_init( &md_ctx );
  mbedtls_md_free( &md_ctx );
  return 0;
}
