local ffi = require('ffi')
local util = require('util')
local gl = require('gl')

local ResourceManager_mt = {}

function ResourceManager_mt:Shader(...)
   local shader = gl.CreateShader(...)
   table.insert(self.shaders, shader)
   return shader
end

function ResourceManager_mt:Program(...)
   local program = gl.CreateProgram(...)
   table.insert(self.programs, program)
   return program
end

function ResourceManager_mt:VAO(...)
   local vao = gl.VAO(...)
   table.insert(self.vaos, vao)
   return vao
end

ResourceManager_mt.VertexArray = ResourceManager_mt.VAO

function ResourceManager_mt:VBO(...)
   local vbo = gl.VBO(...)
   table.insert(self.vbos, vbo)
   return vbo
end

ResourceManager_mt.Buffer = ResourceManager_mt.VBO

function ResourceManager_mt:Texture(...)
   local texture = gl.Texture(...)
   table.insert(self.textures, texture)
   return texture
end

function ResourceManager_mt:Renderbuffer(...)
   local rb = gl.Renderbuffer(...)
   table.insert(self.renderbuffers, rb)
   return rb
end

function ResourceManager_mt:Framebuffer(...)
   local fb = gl.Framebuffer(...)
   table.insert(self.framebuffers, fb)
   return fb
end

function ResourceManager_mt:delete()
   for _,texture in ipairs(self.textures) do texture:delete() end
   self.textures = {}
   for _,vao in ipairs(self.vaos) do vao:delete() end
   self.vaos = {}
   for _,vbo in ipairs(self.vbos) do vbo:delete() end
   self.vbos = {}
   for _,program in ipairs(self.programs) do program:detach_all() end
   for _,shader in ipairs(self.shaders) do shader:delete() end
   self.shaders = {}
   for _,program in ipairs(self.programs) do program:delete() end
   self.programs = {}
   for _,fb in ipairs(self.framebuffers) do fb:delete() end
   self.framebuffers = {}
   for _,rb in ipairs(self.renderbuffers) do rb:delete() end
   self.renderbuffers = {}
end

ResourceManager_mt.__index = ResourceManager_mt

local function ResourceManager()
   local self = {
      shaders = {},
      programs = {},
      vaos = {},
      vbos = {},
      textures = {},
      renderbuffers = {},
      framebuffers = {},
   }
   return setmetatable(self, ResourceManager_mt)
end

return ResourceManager
