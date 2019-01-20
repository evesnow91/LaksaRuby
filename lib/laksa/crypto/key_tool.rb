require 'secp256k1'
require 'digest'

module Laksa
  module Crypto
    class KeyTool
      include Secp256k1
      def initialize(private_key)
        is_raw = private_key.length == 32 ? true : false

        @pk = PrivateKey.new(privkey: private_key, raw: is_raw)
      end

      def self.generate_private_key
        KeyTool.generate_random_bytes(64)
      end

      def self.generate_random_bytes(size)
        SecureRandom.random_bytes(size)
      end

      def get_public_key(is_compressed = true)
        Utils.encode_hex @pk.pubkey.serialize(compressed: is_compressed)
      end

      def get_address
        KeyTool.get_address(self.get_public_key)
      end

      def self.get_address(public_key = nil)
        orig_address = Digest::SHA256.hexdigest Utils.decode_hex public_key
        orig_address[24..-1]
      end
    end
  end
end